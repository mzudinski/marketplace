run.job "Standard Deviation" {
  main = {name: "Standard Deviation", input: {}}
}
---
// Return the standard deviation of the provided `values`. Set `is_sample` to `true` when submitting a partial data set instead of a complete population.
// 
// ## Example
// 
// ```
// {
//   "values": [1,2,3,4,5],
//   "is_sample": false
// }
// ```
// 
// returns
// 
// ```
// 1.4142135623731
// ```
function "Standard Deviation" {
  input {
    decimal[] values?
  
    // Indicate a sample of data instead of a complete data set
    bool is_sample?
  }

  stack {
    var $mean {
      value = $input.values|sum|divide:($input.values|count)
    }
  
    var $count {
      value = $input.values|count
    }
  
    var $std_dev_sum {
      value = []
    }
  
    foreach ($input.values) {
      each as $item {
        array.push $std_dev_sum {
          value = `$item - $mean`|pow:2
        }
      }
    }
  
    var $std_dev {
      value = $std_dev_sum
        |sum
        |divide:($input.is_sample ? $count - 1 : $count)
        |sqrt
    }
  }

  response = $std_dev
}