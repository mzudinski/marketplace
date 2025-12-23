workspace fill_array
---
// Fills elements of `array` with `value` from `start` up to, but not including, `end`.
// 
// For the following input
// ```
// {
//    "array":[1, 2, 3, 4, 5, 6],
//    "value":"replaced",
//    "start":2,
//    "end":4
// }
// ```
// 
// This method returns:
// ```
// [1,2,"replaced","replaced",5,6]
// ```
function "Fill array" {
  input {
    json array?
    json value?
    int start?
    int end?="-1"
  }

  stack {
    var $output {
      value = []
    }
  
    // if no end is provided, we want to replace the whole array
    var $end {
      value = $input.end < 0 ? ($input.array|count) : $input.end
    }
  
    conditional {
      if (($input.array|is_array) === true) {
        for ($input.array|count) {
          each as $index {
            // are we within the set boundaries?
            conditional {
              if ($var.index >= $input.start && $var.index < $end) {
                // replace the value at the current index
                array.push $output {
                  value = $input.value
                }
              }
            
              else {
                // outside the boundaries, keep the original value
                array.push $output {
                  value = $input.array[$var.index]
                }
              }
            }
          }
        }
      }
    
      else {
        // like in lodash, returns the value if it's not an array
        return {
          value = $input.array
        }
      }
    }
  }

  response = $var.output
}