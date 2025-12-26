run.job "Difference array" {
  main = {
    name : "Difference array"
    input: {array_1: [1, 2, 3, 4, 5, 6], array_2: [2, 4, 6]}
  }
}
---
function "Difference array" {
  input {
    json[] array_1?
    json[] array_2?
  }

  stack {
    var $difference {
      value = []
    }
  
    foreach ($input.array_1) {
      each as $item_1 {
        foreach ($input.array_2) {
          each as $item_2 {
            var $is_in_array_2 {
              value = false
            }
          
            conditional {
              if ($item_1 === $item_2) {
                var.update $is_in_array_2 {
                  value = true
                }
              
                break
              }
            }
          }
        }
      
        conditional {
          if ($is_in_array_2 === false) {
            array.push $difference {
              value = $item_1
            }
          }
        }
      }
    }
  }

  response = $difference
}