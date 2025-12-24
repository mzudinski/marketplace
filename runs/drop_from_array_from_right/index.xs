run "Drop right array" {
  type = "job"
  main = {name: "Drop right array", input: {array: [0, 1, 2, 3, 4], n: 2}}
}
---
// Creates a slice of `array` with `n` elements dropped from the end.
function "Drop right array" {
  input {
    json array?
    int n?
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