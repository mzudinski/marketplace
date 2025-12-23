function "Tail of array" {
  input {
    json array?
  }

  stack {
    conditional {
      if (($input.array|is_text) === true) {
        return {
          value = $input.array
            |substr:1:($input.array|count)
            |split:""
        }
      }
    }
  
    conditional {
      if (($input.array|is_array) === true) {
        return {
          value = $input.array|slice:1:($input.array|count)
        }
      }
    }
  }

  response = []
}