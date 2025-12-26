run.job "Linear Regression" {
  main = {
    name : "Linear Regression"
    input: {x: [1.1, 2.05, 2.98, 4.1, 5.01], y: [0.9, 1.9, 2.8, 4.1, 5.1]}
  }
}
---
// Performs simple linear regression and returns the slope, intercept, standard errors, residual variance, and R² goodness-of-fit score.
// 
// ```
// {
//   "x": [
//     1.1,
//     2.05,
//     2.98,
//     4.1,
//     5.01
//   ],
//   "y": [
//     0.9,
//     1.9,
//     2.8,
//     4.1,
//     5.1
//   ]
// }
// ```
function "Linear Regression" {
  input {
    // the X dataset
    decimal[] x?
  
    // The Y dataset
    decimal[] y?
  }

  stack {
    precondition (($input.x|count) == ($input.y|count)) {
      error_type = "inputerror"
      error = "Both dataset should have the same length"
    }
  
    var $n {
      value = $input.x|count
    }
  
    action.call "" {
      package = ""
      input = {values: $input.x}
    } as $x_mean
  
    action.call "" {
      package = ""
      input = {values: $input.y}
    } as $y_mean
  
    action.call "" {
      package = ""
      input = {numbers: $input.x, op: "subtract", value: $x_mean}
    } as $x_var
  
    action.call "" {
      package = ""
      input = {numbers: $input.y, op: "subtract", value: $y_mean}
    } as $y_var
  
    action.call "" {
      package = ""
      input = {numbers_a: $x_var, numbers_b: $y_var}
    } as $s_xy
  
    action.call "" {
      package = ""
      input = {numbers_a: $x_var, numbers_b: $x_var}
    } as $s_xx
  
    var $slope {
      value = $s_xy / $s_xx
    }
  
    var $intercept {
      value = $y_mean - ($slope * $x_mean)
    }
  
    action.call "" {
      package = ""
      input = {numbers: $input.x, op: "multiply", value: $slope}
    } as $y_pred
  
    action.call "" {
      package = ""
      input = {numbers: $y_pred, op: "add", value: $intercept}
    } as $y_pred
  
    action.call "" {
      package = ""
      input = {
        left_numbers : $input.y
        op           : "subtract"
        right_numbers: $y_pred
      }
    } as $residuals
  
    action.call "" {
      package = ""
      input = {numbers: $residuals, op: "power", value: 2}
    } as $ss_res|sum
  
    action.call "" {
      package = ""
      input = {numbers: $input.y, op: "subtract", value: $y_mean}
    } as $ss_tot
  
    action.call "" {
      package = ""
      input = {numbers: $ss_tot, op: "power", value: 2}
    } as $ss_tot|sum
  
    var $r_squared {
      value = 1 - ($ss_res / $ss_tot)
    }
  
    // residual variance
    var $s2 {
      value = $ss_res / ($n - 2)
    }
  
    var $stderr_slope {
      value = `$s2 / $s_xx`|sqrt
    }
  
    var $stderr_intercept {
      value = `$s2 * (1/$n + (($x_mean * $x_mean)/$s_xx))`|sqrt
    }
  }

  response = {
    slope            : $slope
    intercept        : $intercept
    stderr_slope     : $stderr_slope
    stderr_intercept : $stderr_intercept
    r_squared        : $r_squared
    residual_variance: $s2
  }
}