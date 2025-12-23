workspace take_from_array
---
function "Take from array" {
  input {
    json array?
    int n?=1
  }

  stack {
    conditional {
      if ($input.n <= 0) {
        return {
          value = []
        }
      }
    }
  
    conditional {
      if (($input.array|is_text) === true) {
        return {
          value = $input.array|substr:`0`:$input.n|split:""
        }
      }
    }
  
    conditional {
      if (($input.array|is_array) === true) {
        return {
          value = $input.array|slice:0:$input.n
        }
      }
    }
  }

  response = []
}