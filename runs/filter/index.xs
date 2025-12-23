workspace filter
---
// Performs a deep comparison of each element in a collection to the given properties object, returning an array of all elements that have equivalent property values.
// 
// ```json
// {
//   "array": [
//     {
//       "name": "barney",
//       "age": 36,
//       "pets": [
//         "hoppy"
//       ]
//     },
//     {
//       "name": "fred",
//       "age": 40,
//       "pets": [
//         "baby puss",
//         "dino"
//       ]
//     }
//   ],
//   "props": {
//     "pets": [
//       "dino"
//     ]
//   }
// }
// ```
// 
// You can also use an attribute name to check if it's truthy
// 
// ```json
// {
//   "array": [
//     {
//       "subscribed": true,
//       "firstName": "tom",
//       "lastName": "bradley"
//     },
//     {
//       "subscribed": false,
//       "firstName": "tom",
//       "lastName": "hanks"
//     },
//     {
//       "subscribed": false,
//       "firstName": "jim",
//       "lastName": "carrey"
//     },
//     {
//       "subscribed": true,
//       "firstName": "fred",
//       "lastName": "astaire"
//     }
//   ],
//   "props": "subscribed"
// }
// 
// ```
function "$main" {
  input {
    object args {
      schema {
        json[] array?
        json props?
      }
    }
  }

  stack {
    var $match {
      value = []
    }
  
    foreach ($input.array) {
      each as $item {
        try_catch {
          try {
            action.call "" {
              package = ""
              input = {object: $item, props: $input.props}
            } as $item_is_match
          
            conditional {
              if ($item_is_match) {
                var.update $match {
                  value = $match|push:$item
                }
              }
            
              else {
                debug.log {
                  value = $item
                }
              }
            }
          }
        
          catch {
            debug.log {
              value = $error.message
            }
          }
        }
      }
    }
  }

  response = $match
}