run "Chunk array" {
  type = "job"
  main = {name: "Chunk array", input: {array: [1, 2, 3, 4, 5], size: 2}}
}
---
// Creates an `array` of elements split into groups the length of `size`. 
// 
// If `array` can't be split evenly, the final chunk will be the remaining elements.
// 
// | parameter | values |
// |------------|--------|
// | array         | [1,2,3,4,5] |
// | size           | 2 |
// 
// gives you a value 
// ```
// [1, 2], [3, 4], [5]
// ```
function "Chunk array" {
  input {
    // The length of each chunk
    int size?=1
  
    // The array to process
    json[] array
  }

  stack {
    var $buffer {
      value = []
    }
  
    var $chuncks {
      value = []
    }
  
    foreach ($input.array) {
      each as $item {
        // Have we reach the proper chunk size?
        conditional {
          if (($buffer|count) == $input.size) {
            // Once we reach the proper chunk size, add it to the final chunks
            array.push $chuncks {
              value = $buffer
            }
          
            // now we can reset the buffer
            var.update $buffer {
              value = []
            }
          }
        }
      
        // Add the item to the current chunk
        array.push $buffer {
          value = $item
        }
      }
    }
  
    // is there any item left in the buffer?
    conditional {
      if (($buffer|count) > 0) {
        // Once we reach the proper chunk size, add it to the final chunks
        array.push $chuncks {
          value = $buffer
        }
      }
    }
  }

  response = $chuncks
}