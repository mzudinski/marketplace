workspace sum
---
// Calculates the total sum of an array of number
function "$main" {
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