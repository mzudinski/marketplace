workspace flatten_array
---
function "$main" {
  input {
    object args {
      schema {
        json[] array?
      }
    }
  }

  stack {
    var $output {
      value = []
    }
  
    foreach ($input.array) {
      each as $item {
        conditional {
          if (($item|is_array) === true) {
            foreach ($item) {
              each as $sub_item {
                array.push $output {
                  value = $sub_item
                }
              }
            }
          }
        
          else {
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