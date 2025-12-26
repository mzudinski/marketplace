run.job "Initial of array" {
  main = {name: "Initial of array", input: {}}
}
---
function "Initial of array" {
  input {
    json array?
  }

  stack {
    conditional {
      if (($input.array|is_text) === true) {
        return {
          value = $input.array|substr:0:-1|split:""
        }
      }
    }
  
    conditional {
      if (($input.array|is_array) === true) {
        return {
          value = $input.array|slice:0:-1
        }
      }
    }
  }

  response = null
}