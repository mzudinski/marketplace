// Creates an array with all falsey values removed. The values false, null, 0, `""` (empty string), `{}` (empty object) , `[]` (empty array) are falsey.
function "Compact array" {
  input {
    json[] array?
  }

  stack {
    // output will store all the truthy values
    var $output {
      value = []
    }
  
    // Go other every items in the array and add them to the output
    foreach ($input.array) {
      each as $item {
        var $item_is_bool {
          value = $item|is_bool
        }
      
        conditional {
          if ($item_is_bool && $item === true) {
            array.push $output {
              value = $item
            }
          }
        }
      
        var $item_is_text {
          value = $item|is_text
        }
      
        conditional {
          if ($item_is_text === true && ($item|strlen) > 0) {
            array.push $output {
              value = $item
            }
          }
        }
      
        var $item_is_object {
          value = $item|is_object
        }
      
        conditional {
          if ($item_is_object === true && $item != {}) {
            array.push $output {
              value = $item
            }
          }
        }
      
        var $item_is_array {
          value = $item|is_array
        }
      
        conditional {
          if ($item_is_array === true && ($item|count) > 0) {
            array.push $output {
              value = $item
            }
          }
        }
      
        var $item_is_int {
          value = $item|is_int
        }
      
        conditional {
          if ($item_is_int === true && $item !== 0) {
            array.push $output {
              value = $item
            }
          }
        }
      
        var $item_is_decimal {
          value = $item|is_decimal
        }
      
        conditional {
          if ($item_is_decimal === true && $item !== 0) {
            array.push $output {
              value = $item
            }
          }
        }
      }
    }
  }

  response = $var.output
}