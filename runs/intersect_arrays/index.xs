workspace intersect_arrays
---
// Creates an array of unique values that are included in all given `arrays` using equality comparisons. The order and references of result values are determined by the first array.
// 
// ## Example
// 
// ```
// {
//   "array_1": [1,2,3],
//   "array_2": [1,2],
//   "array_3": [2,3]
// }
// ```
// 
// returns
// ```
// [2]
// ```
function "$main" {
  input {
    json array_1
    json array_2?
    json array_3?
    json array_4?
    json array_5?
  }

  stack {
    var $output {
      value = $input.array_1|unique:""
    }
  
    var $arrays {
      value = []
        |push:$input.array_2
        |push:$input.array_3
        |push:$input.array_4
        |push:$input.array_5
    }
  
    foreach ($arrays) {
      each as $array {
        conditional {
          if ($input.array_2 !== null && ($input.array_2|is_array) === true) {
            var.update $output {
              value = $var.output|unique:""|intersect:$array
            }
          }
        }
      }
    }
  }

  response = $var.output
}