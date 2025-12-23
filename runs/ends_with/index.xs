workspace ends_with
---
// Checks if `string` (or `array`) ends with the given `target` string (or `array`).
// 
// ## Example
// 
// ```
// {
//   "text": "some string",
//   "target": "ing"
// }
// ```
// 
// returns 
// ```
// true
// ```
function "Ends with" {
  input {
    json text?
    json target?
    int position?="-1"
  }

  stack {
    var $text {
      value = $input.text
    }
  
    var $target {
      value = $input.target
    }
  
    // Convert any string into an array of characters
    conditional {
      if (($input.text|is_text) === true) {
        var.update $text {
          value = $text|split:""
        }
      }
    }
  
    // Convert any string into an array of characters
    conditional {
      if (($target|is_text) === true) {
        var.update $target {
          value = $target|split:""
        }
      }
    }
  
    // If we still have a single value, make it an array with a single element
    conditional {
      if (($target|is_array) !== true) {
        var.update $target {
          value = []|push:$target
        }
      }
    }
  
    var $position {
      value = $input.position > -1 ? $input.position : ($var.text|count)
    }
  
    // Now we should only have arrays in target and text variables
    for ($target|count) {
      each as $index {
        // compare every element using position as an offset on the string
        conditional {
          if (($text|get:$var.position - $var.index - 1:null) !== ($target|get:($var.target|count) - $index - 1:null)) {
            return {
              value = false
            }
          }
        }
      }
    }
  }

  response = true
}