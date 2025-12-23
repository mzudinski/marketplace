workspace sum
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