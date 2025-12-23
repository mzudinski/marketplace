workspace key_by_array
---
function "$main" {
  input {
    object args {
      schema {
        json collection?
        text path? filters=trim
      }
    }
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
          
            var.update $output {
              value = $var.output|set:$key:$item
            }
          }
        }
      }
    }
  }

  response = $var.output
}