workspace skewness
---
// Measures the asymmetry of a data set’s distribution around its mean.
function "$main" {
  input {
    object args {
      schema {
        decimal[] numbers?
        bool bias?
      }
    }
  }

  stack {
    var $n {
      value = $input.numbers|count
    }
  
    conditional {
      if ($n == 0 || $n == 1) {
        return {
          value = 0
        }
      }
    }
  
    action.call "" {
      package = ""
      input = {numbers: $input.numbers, power: 3, bias: $input.bias}
    } as $third_moment
  
    action.call "" {
      package = ""
      input = {numbers: $input.numbers, power: 2, bias: $input.bias}
    } as $second_moment
  
    conditional {
      if ($second_moment == 0) {
        return {
          value = 0
        }
      }
    }
  
    var $skewness {
      value = $third_moment|divide:($second_moment|pow:1.5)
    }
  }

  response = $skewness
}