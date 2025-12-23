function Percentile {
  input {
    // Array of numbers to calculate the percentile from
    decimal[] numbers?
  
    // The percentile to calculate (0-100)
    decimal percentile? filters=min:1|max:100
  }

  stack {
    // Sort the numbers in ascending order.
    var $sorted_numbers {
      value = `$input.numbers|sort:$this:number:true`
    }
  
    // Calculate the index corresponding to the percentile.
    var $index {
      value = (($input.percentile / 100) * (($sorted_numbers|count) - 1))
    }
  
    // The lower bound index for interpolation.
    var $lower_index {
      value = $var.index|floor|to_int
    }
  
    // The upper bound index for interpolation.
    var $upper_index {
      value = $var.index|ceil|to_int
    }
  
    // Interpolate between the lower and upper index values.
    var $percentile_value {
      value = $sorted_numbers[$lower_index] + ($index - $lower_index) * ($sorted_numbers[$upper_index] - $sorted_numbers[$lower_index])
    }
  }

  response = $percentile_value
}