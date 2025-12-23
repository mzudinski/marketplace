// Compute the factorial of a value
function Factorial {
  input {
    int number?
  }

  stack {
    var $result {
      value = 1
    }
  
    for ($input.number) {
      each as $i {
        // Multiply $result by the current iteration value ($i + 1)
        math.mul $result {
          value = $i + 1
        }
      }
    }
  }

  response = $result
}