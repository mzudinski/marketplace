workspace unique
---
// Creates a duplicate-free version of a collection, using equality comparisons, in which only the first occurrence of each element is kept. The order of result values is determined by the order they occur in the array.
// 
// If a path is provided it will be used to match the objects.
// 
// ## Example
// 
// provided an array:
// ```json
// {
//   "collection": [1,2,3,2]
// }
// ```
// 
// returns 
// ```json
// [1,2,3]
// ```
// 
// provided a text:
// ```json
// {
//   "collection": "test"
// }
// ```
// 
// returns 
// ```json
// ["t", "e", "s"]
// ```
// 
// Provided a collection of object
// 
// ```json
// {
//   "collection": [
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
//     },
//     {
//       "id": 12,
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
// 
// it will return all the object with a unique email
function "$main" {
  input {
    object args {
      schema {
        json[] collection?
      
        // optional path value to compare elements
        text? path? filters=trim
      }
    }
  }

  stack {
    conditional {
      if (($input.collection|is_text) === true) {
        return {
          value = $input.collection|split:""|unique:""
        }
      }
    }
  
    conditional {
      if (($input.collection|is_array) === true) {
        conditional {
          if ($input.path != null && ($input.path|strlen) > 0) {
            return {
              value = $input.collection|unique:$input.path
            }
          }
        
          else {
            return {
              value = $input.collection|unique:""
            }
          }
        }
      }
    }
  }

  response = []
}