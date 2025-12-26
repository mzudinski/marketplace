run.job Sum {
  main = {name: "Sum", input: {numbers: [1, 2, 3, 4]}}
}
---
// Calculates the total sum of an array of number
function Sum {
  input {
    decimal[] numbers?
  }

  stack {
    var $sum {
      value = $input.numbers|sum
    }
  }

  response = $sum
}