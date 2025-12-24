run "Last array" {
  type = "job"
  main = {name: "Last array", input: {array: [1, 2, 3, 4, 5]}}
}
---
function "Last array" {
  input {
    json array?
  }

  stack {
    conditional {
      if ($input.array|is_text) {
        return {
          value = $input.array|substr:-1:1
        }
      }
    }
  
    conditional {
      if ($input.array|is_array) {
        return {
          value = $input.array|last
        }
      }
    }
  }

  response = null
}