workspace kurtosis_fisher
---
// The kurtosis measures the "tailedness" of a distribution, showing whether the data has heavy or light tails compared to a normal distribution.
// 
// This action returns Fisher kurtosis, to get the raw kurtosis you can add 3 to its result.
function "$main" {
  input {
    decimal[] numbers?
  
    // Set the bias to false for small dataset
    bool bias?=true
  }

  stack {
    var $n {
      value = $input.numbers|count
    }
  
    // Unbias kurtosis requires at least 4 values
    precondition ($n > 3) {
      error_type = "inputerror"
      error = "Kurtosis requires at least 4 values"
    }
  
    action.call "" {
      package = ""
      input = {values: $input.numbers}
    } as $mean
  
    action.call "" {
      package = ""
      input = {numbers: $input.numbers, bias: $input.bias}
    } as $s2
  
    action.call "" {
      package = ""
      input = {
        numbers: $input.numbers
        op     : "subtract"
        value  : $mean
      }
    } as $variations
  
    action.call "" {
      package = ""
      input = {numbers: $variations, op: "power", value: 4}
    } as $m4
  
    conditional {
      if ($input.bias) {
        action.call "" {
          package = ""
          input = {values: $m4}
        } as $biased_fourth_central_moment
      
        var $kurtosis {
          value = $biased_fourth_central_moment / ($var.s2|pow:2) - 3
        }
      }
    
      else {
        var $numerator {
          value = ($n * ($n + 1) * ($m4|sum)) / (($n - 1) * ($n - 2) * ($n - 3))
        }
      
        var $denominator {
          value = $s2|pow:2
        }
      
        var $correction {
          value = (3 * ($n - 1)* ($n - 1)) / (($n - 2) * ($n - 3))
        }
      
        var $kurtosis {
          value = $numerator
            |divide:$denominator
            |subtract:$correction
        }
      }
    }
  }

  response = $kurtosis
}