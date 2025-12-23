// Creates an array of unique values that is the [symmetric difference](https://en.wikipedia.org/wiki/Symmetric_difference) of the given two arrays. The order of result values is determined by the order they occur in the arrays.
// 
// ## Example
// 
// ```
// {
//   "array_1": [1, 2],
//   "array_2": [2, 3]
// }
// ```
// 
// returns
// 
// ```
// [1, 2]
// ```
function "Xor array" {
  input {
    json[] array_1?
    json[] array_2?
  }

  stack {
    var $diff_1 {
      value = $input.array_1|unique:""|diff:$input.array_2
    }
  
    var $diff_2 {
      value = $input.array_2|unique:""|diff:$input.array_1
    }
  }

  response = $diff_1|merge:$diff_2
}