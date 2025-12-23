workspace drop_from_array_from_right
---
// Creates a slice of `array` with `n` elements dropped from the end.
function "$main" {
  input {
    object args {
      schema {
        json array?
        int n?
      }
    }
  }

  stack {
    conditional {
      if ($input.array|is_array) {
        conditional {
          if ($input.n > 0) {
            return {
              value = $input.array|slice:0:0 - $input.n
            }
          }
        
          else {
            return {
              value = $input.array
            }
          }
        }
      }
    }
  }

  response = []
}