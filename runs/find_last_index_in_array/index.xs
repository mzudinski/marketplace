workspace find_last_index_in_array
---
// This method is like `Find index in array` except that it iterates over elements of collection from right to left.
function "Find last index in array" {
  input {
    json array?
    json predicate?
  }

  stack {
    var $length {
      value = $input.array|count
    }
  
    conditional {
      if (($input.array|is_array) === true) {
        for ($input.array|count) {
          each as $index {
            conditional {
              if (($input.array[$var.length - $var.index] === $input.predicate) === true) {
                return {
                  value = $var.length - $var.index
                }
              }
            }
          }
        }
      }
    }
  }

  response = -1
}