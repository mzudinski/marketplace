function "Remove from array" {
  input {
    json array?
    json[] values?
  }

  stack {
    var $output {
      value = []
    }
  
    foreach ($input.array) {
      each as $item {
        conditional {
          if (($input.values|in:$item) === true) {
          }
        
          else {
            array.push $output {
              value = $item
            }
          }
        }
      }
    }
  }

  response = $var.output
}