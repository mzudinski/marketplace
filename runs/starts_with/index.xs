workspace starts_with
---
// Checks if `string` (or `array`) starts with the given `target` string (or `array`).
// 
// ## Example
// 
// ```
// {
//   "text": "value",
//   "target": "lue",
//   "position": 2,
// }
// ```
// 
// returns 
// ```
// true
// ```
function "$main" {
  input {
    object args {
      schema {
        json text?
        json target?
        int position?
      }
    }
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
  
    // Now we should only have arrays in target and text variables
    for ($target|count) {
      each as $index {
        // compare every element using position as an offset on the string
        conditional {
          if (($text|get:$var.index + $input.position:null) !== ($target|get:$var.index:null)) {
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