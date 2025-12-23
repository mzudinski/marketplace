workspace sum_of_products
---
// Calculates the sum of the element-wise products of two arrays, requiring two input arrays of equal length.
function "$main" {
  input {
    object args {
      schema {
        decimal[] numbers_a?
        decimal[] numbers_b?
      }
    }
  }

  stack {
    var $sum {
      value = 0
    }
  
    // Size of the input arrays.
    var $size {
      value = $input.numbers_b|count
    }
  
    precondition ($size == ($input.numbers_a|count)) {
      error_type = "inputerror"
      payload = "Both arrays must have the same length."
    }
  
    for ($size) {
      each as $index {
        // Computes the product at $index in both arrays
        var $product {
          value = $input.numbers_a[$index] * $input.numbers_b[$index]
        }
      
        // Add the product of the current pair to the sum.
        math.add $sum {
          value = $product
        }
      }
    }
  }

  response = $sum
}