workspace union
---
// Returns a collection of unique elements from both left and right. Optional path allow you to specify the path to the value used for matching.
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
    text? path? filters=trim
  }

  stack {
    conditional {
      if (($input.right_collection|is_array) == false && ($input.left_collection|is_array) == false) {
        return {
          value = []
        }
      }
    
      elseif (($input.left_collection|is_array) == false) {
        var.update $output {
          value = $input.right_collection
        }
      }
    
      elseif (($input.right_collection|is_array) == false) {
        var.update $output {
          value = $input.left_collection
        }
      }
    
      else {
        action.call "" {
          package = ""
          input = {
            array_1: $input.left_collection
            array_2: $input.right_collection
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
    }
  
    conditional {
      if ($input.path != null) {
        action.call "" {
          package = ""
          input = {collection: $var.output, path: $input.path}
        } as $output
      }
    
      else {
        var.update $output {
          value = $var.output|unique:""
        }
      }
    }
  }

  response = $var.output
}