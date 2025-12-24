run Difference {
  type = "job"
  main = {
    name : "Difference"
    input: {
      left_collection : [
        {id: 1, name: "john", age: 24, email: "johnny@example.com"}
        {id: 2, name: "ted", age: 34, email: "ted@example.com"}
        {id: 12, name: "johnny", age: 24, email: "johnny@example.com"}
      ]
      right_collection: [
        {id: 2, name: "ted", age: 34, email: "ted@example.com"}
        {id: 3, name: "johnny", age: 24, email: "john@example.com"}
        {id: 4, name: "fred", age: 33, email: "fred@example.com"}
      ]
      path            : "email"
    }
  }
}
---
// Creates an array of array values not included in the other given arrays. The order and references of result values are determined by the first array.
// 
// When comparing two collections of objects, the path is a required argument.
// 
// ## Examples
// 
// Collections of value difference
// 
// ```json
// {
//   "left_collection": [1,1,2,3,3,4,5],
//   "right_collection": [4,5,6,7,8]
// }
// ```
// 
// Collections of objects difference
// 
// ```json
// {
//   "left_collection": [
//     {
//       "id": 1,
//       "name": "john",
//       "age": 24,
//       "email": "johnny@example.com"
//     },
//     {
//       "id": 2,
//       "name": "ted",
//       "age": 34,
//       "email": "ted@example.com"
//     },
//     {
//       "id": 12,
//       "name": "johnny",
//       "age": 24,
//       "email": "johnny@example.com"
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
function Difference {
  input {
    json[] left_collection?
    json[] right_collection?
    text? path? filters=trim
  }

  stack {
    var $output {
      value = []
    }
  
    conditional {
      if (($input.left_collection|is_array) != true) {
        return {
          value = []
        }
      }
    }
  
    conditional {
      if (($input.right_collection|is_array) != true) {
        return {
          value = $input.left_collection
        }
      }
    }
  
    conditional {
      if ($input.path != null && ($input.path|strlen) > 0) {
        foreach ($input.left_collection) {
          each as $left {
            var $has_match {
              value = false
            }
          
            foreach ($input.right_collection) {
              each as $right {
                conditional {
                  if (($left|get:$input.path:null) == ($right|get:$input.path:null)) {
                    var.update $has_match {
                      value = true
                    }
                  
                    break
                  }
                }
              }
            }
          
            conditional {
              if ($has_match == false) {
                array.push $output {
                  value = $left
                }
              }
            }
          }
        }
      }
    
      else {
        var.update $output {
          value = $input.left_collection|diff:$input.right_collection
        }
      }
    }
  
    action.call "" {
      package = ""
      input = {collection: $var.output, path: $input.path}
    } as $output
  }

  response = $var.output
}