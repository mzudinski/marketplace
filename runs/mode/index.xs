workspace mode
---
// Identifies the most frequently occurring value(s) in a data set
function "$main" {
  input {
    decimal[] numbers?
  }

  stack {
    // Map to store the frequency of each number.
    var $frequency_map {
      value = {}
    }
  
    foreach ($input.numbers) {
      each as $number {
        var $count {
          value = $frequency_map|get:$number:null
        }
      
        // Increment the frequency count for $number.
        var.update $frequency_map {
          value = $frequency_map
            |set:$number:($count ? $count + 1 : 1)
        }
      }
    }
  
    // The highest frequency in the dataset.
    var $max_frequency {
      value = $frequency_map|values|max
    }
  
    // Array to store the mode(s).
    var $modes {
      value = []
    }
  
    foreach ($frequency_map|entries) {
      each as $entry {
        conditional {
          if ($max_frequency == ($entry|get:"value":null)) {
            // Add the number to the modes array if its frequency matches the max frequency.
            array.push $modes {
              value = $entry|get:"key":null
            }
          }
        }
      }
    }
  }

  response = $modes
}