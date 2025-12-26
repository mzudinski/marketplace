run.job "Average of values" {
  main = {name: "Average of values", input: {}}
}
---
// Compute the average (aka. mean) of provided `values`
function "Average of values" {
  input {
    decimal[] values?
  }

  stack {
    conditional {
      if (($input.values|count) > 0) {
        return {
          value = $input.values|avg
        }
      }
    }
  }

  response = 0
}