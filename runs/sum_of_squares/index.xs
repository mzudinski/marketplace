run.job "Sum of squares" {
  main = {name: "Sum of squares", input: {numbers: [1, 2, 3, 4, 5]}}
}
---
// The sum of squares is the result of squaring each number in a set and then adding those squares together.
function "Sum of squares" {
  input {
    decimal[] numbers?
  }

  stack {
    var $sum {
      value = 0
    }
  
    foreach ($input.numbers) {
      each as $number {
        // Compute the square
        var $square {
          value = $number|multiply:$number
        }
      
        math.add $sum {
          value = $square
        }
      }
    }
  }

  response = $sum
}