// Recursively flattens `array`.
// 
// for the following input
// ```
// {
//   "array": [1, [2, [3, [4]], 5]]
// }
// ```
// 
// the return value is
// ```
// [1, 2, 3, 4, 5]
// ```
function "Flatten deep array" {
  input {
    json[] array?
  }

  stack {
    var $output {
      value = []
    }
  
    foreach ($input.array) {
      each as $item {
        conditional {
          if (($item|is_array) === true) {
            action.call "" {
              package = ""
              input = {array: $item}
            } as $flatten
          
            action.call "" {
              package = ""
              input = {
                array_1: $var.output
                array_2: $flatten
                array_3: []
                array_4: []
                array_5: []
                array_6: []
                array_7: []
                array_8: []
                array_9: []
              }
            } as $output
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