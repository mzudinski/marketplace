workspace map_array
---
// Creates an array of values by running each element in collection thru the `path`.
// 
// When provided an object, map will use the object's values as the collection
// 
// ## Example
// 
// ```
// {
//   "array": [
//     {"a": true, "b": false},
//     {"a": false, "b": true}, 
//     {"a": true, "b": true},
//     {"a": false, "b": false}
//   ],
//   "path": "a"
// }
// ```
// 
// will return
// 
// ```
// [true, false, true, false]
// ```
function "Map array" {
  input {
    json collection?
    text path? filters=trim
  }

  stack {
    // use the values of the object when an object is received as argument
    conditional {
      if (($input.collection|is_object) === true) {
        var $values {
          value = $input.collection|values
        }
      
        function.run "" {
          input = {array: $values, path: $input.path}
        } as $output
      
        return {
          value = $var.output
        }
      }
    }
  
    var $output {
      value = []
    }
  
    conditional {
      if (($input.collection|is_array) === true) {
        foreach ($input.collection) {
          each as $item {
            array.push $output {
              value = $item|get:$input.path:null
            }
          }
        }
      }
    }
  }

  response = $var.output
}