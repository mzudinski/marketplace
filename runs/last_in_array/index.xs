workspace last_in_array
---
function "$main" {
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