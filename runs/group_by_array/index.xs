run "Group by array" {
  type = "job"
  main = {
    name : "Group by array"
    input: {
      collection: [
        {var: "a", value: 10}
        {var: "b", value: 20}
        {var: "c", value: 3}
        {var: "a", value: 44}
      ]
      path      : "var"
    }
  }
}
---
// Creates an object composed of keys generated from the results of running each element of `collection` thru the provided `path`. The corresponding value of each key is the last element responsible for generating the key.
// 
// ## example
// ```
// {
//   "collection": [
//     { "dir": "left", "code": 97 },
//     { "dir": "right", "code": 100 }
//   ],
//   "path": "dir"
// }
// ```
// 
// returns
// ```
// {
//   "left": {
//     "dir": "left",
//     "code": 97
//   },
//   "right": {
//     "dir": "right",
//     "code": 100
//   }
// }
// ```
function "Group by array" {
  input {
    json collection?
    text path? filters=trim
  }

  stack {
    conditional {
      if (($input.collection|is_object) === true) {
        function.run "" {
          input = {collection: $input.collection|values, path: $input.path}
        } as $output
      
        return {
          value = $var.output
        }
      }
    }
  
    var $output {
      value = {}
    }
  
    conditional {
      if (($input.collection|is_array) === true) {
        foreach ($input.collection) {
          each as $item {
            var $key {
              value = $item|get:$input.path:null
            }
          
            conditional {
              if (($var.output|has:$key) === false) {
                var.update $output {
                  value = $var.output|set:$key:[$var.item]
                }
              }
            
              else {
                var.update $output {
                  value = $var.output
                    |set:$key:($var.output[$var.key]|append:$var.item)
                }
              }
            }
          }
        }
      }
    }
  }

  response = $var.output
}