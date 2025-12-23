workspace central_moment
---
// Compute the central moment at different level (default second). Change the power to compute different central moment.
// 
// ## Second Central Moment
// 
// ```
// {
//   "numbers": [1,2,3,4,5,6,7,8,9,10],
//   "power": 2,
//   "bias": false
// }
// ```
// 
// Second Central Moment (unbiased): `9.166666666666666`
// 
// ## Third Central Moment
// 
// ```
// {
//   "numbers": [1,2,3,4,5,6,7,8,9,10],
//   "power": 3,
//   "bias": false
// }
// ```
// 
// Unbiased Third Central Moment: `0.0`
// 
// 
// 
// ## Fourth Central Moment
// 
// ```
// {
//   "numbers": [1,2,3,4,5,6,7,8,9,10],
//   "power": 4,
//   "bias": false
// }
// ```
// 
// Unbiased Fourth Central Moment: `23.9806547`
function "Central Moment" {
  input {
    decimal[] numbers?
    int power?=2 filters=min:2|max:4
  
    // Set the bias to false for small datasets
    bool bias?=true
  }

  stack {
    var $count {
      value = $input.numbers|count
    }
  
    action.call "" {
      package = ""
      input = {values: $input.numbers}
    } as $mean
  
    conditional {
      if ($input.bias == false) {
        switch ($input.power) {
          case (2) {
            action.call "" {
              package = ""
              input = {
                numbers: $input.numbers
                op     : "subtract"
                value  : $mean
              }
            } as $deviations
          
            action.call "" {
              package = ""
              input = {numbers: $deviations, op: "power", value: 2}
            } as $deviations_squared
          
            var $central_moment {
              value = $deviations_squared|sum|divide:$var.count - 1
            }
          } break
        
          case (3) {
            var $coeff {
              value = $count / (($count -1) * ($count -2))
            }
          
            action.call "" {
              package = ""
              input = {
                numbers: $input.numbers
                op     : "subtract"
                value  : $mean
              }
            } as $deviations
          
            action.call "" {
              package = ""
              input = {numbers: $deviations, op: "power", value: 3}
            } as $deviations_cubed
          
            var $central_moment {
              value = $deviations_cubed|sum|multiply:$coeff
            }
          } break
        
          case (4) {
            action.call "" {
              package = ""
              input = {values: $input.numbers, is_sample: $input.bias}
            } as $std_dev
          
            // numbers - mean
            action.call "" {
              package = ""
              input = {
                numbers: $input.numbers
                op     : "subtract"
                value  : $mean
              }
            } as $deviations
          
            // (numbers - mean / std_dev) ^ 4
            action.call "" {
              package = ""
              input = {
                numbers: $deviations
                op     : "power"
                value  : $input.power
              }
            } as $fourth_powers
          
            var $sum_fourth {
              value = $fourth_powers|sum
            }
          
            var $coeff {
              value = $count  / (($count -1) * ($count -2) * ($count -3))
            }
          
            var $central_moment {
              value = $coeff|multiply:$sum_fourth
            }
          } break
        }
      }
    
      else {
        action.call "" {
          package = ""
          input = {
            numbers: $input.numbers
            op     : "subtract"
            value  : $mean
          }
        } as $deltas
      
        action.call "" {
          package = ""
          input = {numbers: $deltas, op: "power", value: $input.power}
        } as $deltas
      
        var $central_moment {
          value = $deltas|sum|divide:$count
        }
      }
    }
  }

  response = $central_moment
}