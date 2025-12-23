function "FindIndex in array" {
  input {
    json array?
    json predicate?
  }

  stack {
    conditional {
      if (($input.array|is_array) === true) {
        for ($input.array|count) {
          each as $index {
            conditional {
              if (($input.array[$var.index] === $input.predicate) === true) {
                return {
                  value = $var.index
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