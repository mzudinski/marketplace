run "Reverse array" {
  type = "job"
  main = {name: "Reverse array", input: {}}
}
---
function "Reverse array" {
  input {
    json array?
  }

  stack {
    conditional {
      if (($input.array|is_text) === true) {
        return {
          value = $input.array|split:""|reverse
        }
      }
    }
  
    conditional {
      if (($input.array|is_array) === true) {
        return {
          value = $input.array|reverse
        }
      }
    }
  }

  response = []
}