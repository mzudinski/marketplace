workspace op_all
---
// Apply an operation on all the element of an array
function "$main" {
  input {
    decimal[] numbers?
    enum op? {
      values = ["add", "subtract", "divide", "multiply", "power"]
    }
  
    // a single value or an array of values the same size as the numbers
    json value?
  }

  stack {
    conditional {
      if ($input.value|is_array) {
        action.call "" {
          package = ""
          input = {
            left_numbers : $input.numbers
            op           : $input.op
            right_numbers: $input.value
          }
        } as $result
      }
    
      else {
        var $result {
          value = []
        }
      
        foreach ($input.numbers) {
          each as $number {
            switch ($input.op) {
              case ("add") {
                array.push $result {
                  value = $number + $input.value
                }
              } break
            
              case ("subtract") {
                array.push $result {
                  value = $number - $input.value
                }
              } break
            
              case ("divide") {
                array.push $result {
                  value = $number / $input.value
                }
              } break
            
              case ("multiply") {
                array.push $result {
                  value = $number * $input.value
                }
              } break
            
              case ("power") {
                array.push $result {
                  value = `$number|pow:$input.value`
                }
              } break
            }
          }
        }
      }
    }
  }

  response = $result
}