// apply the operation from one array to the other
function op_two_array {
  input {
    decimal[] left_numbers?
    enum op?=add {
      values = ["add", "subtract", "multiply", "divide", "power"]
    }
  
    decimal[] right_numbers?
  }

  stack {
    var $result {
      value = []
    }
  
    precondition (($input.left_numbers|count) == ($input.right_numbers|count)) {
      error = "Both sets should have the same size"
    }
  
    for ($input.left_numbers|count) {
      each as $index {
        var $left {
          value = `$input.left_numbers`|get:$var.index:0
        }
      
        var $right {
          value = $input.right_numbers|get:$var.index:null
        }
      
        switch ($input.op) {
          case ("add") {
            array.push $result {
              value = $left + $right
            }
          } break
        
          case ("subtract") {
            array.push $result {
              value = $left- $right
            }
          } break
        
          case ("divide") {
            array.push $result {
              value = $left / $right
            }
          } break
        
          case ("multiply") {
            array.push $result {
              value = $left * $right
            }
          } break
        
          case ("power") {
            array.push $result {
              value = `$left|pow:$right`
            }
          } break
        }
      }
    }
  }

  response = $result
}