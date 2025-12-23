workspace average_of_values_mean
---
// Compute the average (aka. mean) of provided `values`
function "$main" {
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