workspace intersection
---
// Returns the elements from left that have a match in right. Optional path allow you to specify the path to the value used for matching.
// 
// ## Examples 
// 
// ```json
// {
//   "left_collection": [1,2,3,4,5,3],
//   "right_collection": [3,4,5,6,7]
// }
// ```
// 
// ```json
// {
//   "left_collection": [
//     {
//       "id": 1,
//       "name": "john",
//       "age": 24,
//       "email": "john@example.com"
//     },
//     {
//       "id": 2,
//       "name": "ted",
//       "age": 34,
//       "email": "ted@example.com"
//     }
//   ],
//   "right_collection": [
//     {
//       "id": 2,
//       "name": "ted",
//       "age": 34,
//       "email": "ted@example.com"
//     },
//     {
//       "id": 3,
//       "name": "johnny",
//       "age": 24,
//       "email": "john@example.com"
//     },
//     {
//       "id": 4,
//       "name": "fred",
//       "age": 33,
//       "email": "fred@example.com"
//     }
//   ],
//   "path": "email"
// }
// ```
function "$main" {
  input {
    json[] left_collection?
    json[] right_collection?
  
    // Optional object key to retrieve attribute to use for matching
    text? path? filters=trim
  }

  stack {
    var $output {
      value = []
    }
  
    conditional {
      if (($input.left_collection|is_array) != true || ($input.right_collection|is_array) != true) {
        return {
          value = []
        }
      }
    
      elseif ($input.path != null && ($input.path|trim:""|strlen) > 0) {
        action.call "" {
          package = ""
          input = {collection: $input.left_collection, path: $input.path}
        } as $left_collection
      
        action.call "" {
          package = ""
          input = {collection: $input.right_collection, path: $input.path}
        } as $right_collection
      
        foreach ($left_collection) {
          each as $left {
            foreach ($right_collection) {
              each as $right {
                conditional {
                  if (($left|get:$input.path:null) == ($right|get:$input.path:null)) {
                    array.push $output {
                      value = $left
                    }
                  
                    break
                  }
                }
              }
            }
          }
        }
      }
    
      else {
        var.update $output {
          value = $input.left_collection
            |intersect:$input.right_collection
            |unique:""
        }
      }
    }
  }

  response = $var.output
}