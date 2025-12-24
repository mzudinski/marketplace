run "Drop array" {
  type = "job"
  main = {name: "Drop array", input: {array: [0, 1, 2, 3, 4], n: 2}}
}
---
// Creates a slice of `array` with `n` elements dropped from the beginning.
// 
// ```
// {
//   "array": [
//     1,
//     2,
//     3,
//     4
//   ],
//   "n": 3
// }
// ```
// 
// returns 
// 
// ```
// [4]
// ```
function "Drop array" {
  input {
    json[] array?
    int n?
  }

  stack {
    conditional {
      if (($input.array|is_array) === true) {
        return {
          value = $input.array
            |slice:$input.n:($input.array|count)
        }
      }
    }
  }

  response = []
}