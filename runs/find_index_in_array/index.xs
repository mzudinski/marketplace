run.job "FindIndex in array" {
  main = {
    name : "FindIndex in array"
    input: {
      array    : [
        {name: "barney", age: 36, blocked: false}
        {name: "fred", age: 40, blocked: true}
        {name: "pebbles", age: 1, blocked: false}
      ]
      predicate: {age: 36}
    }
  }
}
---
function "FindIndex in array" {
  input {
    json array?
    json predicate?
  }

  stack {
    conditional {
      if (($input.array|is_array) === true) {
        for ($input.array|count) {
          each as $index {
            conditional {
              if (($input.array[$var.index] === $input.predicate) === true) {
                return {
                  value = $var.index
                }
              }
            }
          }
        }
      }
    }
  }

  response = -1
}