workspace to_pairs
---
// Creates an array of own enumerable string keyed-value pairs for `collection` which can be consumed by `From pairs`. If object is a map or set, its entries are returned.
// 
// ## Example
// ```
// {
//   "collection": {"a": 1, "b": 2}
// }
// ```
// 
// returns
// ```
// [["a", 1], ["b", 2]]
// ```
function "$main" {
  input {
    json collection?
  }

  stack {
    var $output {
      value = []
    }
  
    conditional {
      if (($input.collection|is_object) === true) {
        foreach ($input.collection|keys) {
          each as $key {
            array.push $output {
              value = []
                |append:$key:""
                |append:($input.collection|get:$key:null):""
            }
          }
        }
      }
    }
  
    conditional {
      if (($input.collection|is_array) === true) {
        for ($input.collection|count) {
          each as $index {
            array.push $output {
              value = []
                |append:$var.index:""
                |append:($input.collection|get:$var.index:null):""
            }
          }
        }
      }
    }
  }

  response = $var.output
}