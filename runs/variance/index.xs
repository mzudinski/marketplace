// Compute the variance of a sample or population
// 
// Set the bias to false for small population
// 
// ```
// {
//   "numbers": [1,2,3,4,5,6],
//   "bias": false
// }
// ```
// 
// returns a variance of `2.9166666666666665`
// 
// with a bias
// 
// ```
// {
//   "numbers": [1,2,3,4,5,6],
//   "bias": true
// }
// ```
// 
// returns `3.5`
function Variance {
  input {
    decimal[] numbers?
  
    // set to false for small dataset
    bool bias?=true
  }

  stack {
    action.call "" {
      package = ""
      input = {values: $input.numbers}
    } as $mean
  
    var $count {
      value = $input.numbers|count
    }
  
    action.call "" {
      package = ""
      input = {
        numbers: $input.numbers
        op     : "subtract"
        value  : $mean
      }
    } as $deltas
  
    action.call "" {
      package = ""
      input = {numbers: $deltas, op: "power", value: 2}
    } as $deltas
  
    var $delta_sum {
      value = $deltas|sum
    }
  
    var $variance {
      value = $delta_sum
        |divide:($input.bias ? $count : $count - 1)
    }
  }

  response = $variance
}