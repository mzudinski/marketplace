workspace concat_arrays
---
function "$main" {
  input {
    object args {
      schema {
        json[] array_1?
        json[] array_2?
        json[] array_3?
        json[] array_4?
        json[] array_5?
        json[] array_6?
        json[] array_7?
        json[] array_8?
        json[] array_9?
      }
    }
  }

  stack {
    var $array {
      value = []
    }
  
    conditional {
      if (($input.array_1|is_array) === true) {
        foreach ($input.array_1) {
          each as $item {
            array.push $array {
              value = $item
            }
          }
        }
      }
    
      else {
        array.push $array {
          value = $input.array_1
        }
      }
    }
  
    conditional {
      if (($input.array_1|is_array) === true) {
        foreach ($input.array_2) {
          each as $item {
            array.push $array {
              value = $item
            }
          }
        }
      }
    
      else {
        array.push $array {
          value = $input.array_2
        }
      }
    }
  
    conditional {
      if (($input.array_3|is_array) === true) {
        foreach ($input.array_3) {
          each as $item {
            array.push $array {
              value = $item
            }
          }
        }
      }
    
      else {
        array.push $array {
          value = $input.array_3
        }
      }
    }
  
    conditional {
      if (($input.array_4|is_array) === true) {
        foreach ($input.array_4) {
          each as $item {
            array.push $array {
              value = $item
            }
          }
        }
      }
    
      else {
        array.push $array {
          value = $input.array_4
        }
      }
    }
  
    conditional {
      if (($input.array_5|is_array) === true) {
        foreach ($input.array_5) {
          each as $item {
            array.push $array {
              value = $item
            }
          }
        }
      }
    
      else {
        array.push $array {
          value = $input.array_5
        }
      }
    }
  
    conditional {
      if (($input.array_6|is_array) === true) {
        foreach ($input.array_6) {
          each as $item {
            array.push $array {
              value = $item
            }
          }
        }
      }
    
      else {
        array.push $array {
          value = $input.array_6
        }
      }
    }
  
    conditional {
      if (($input.array_7|is_array) === true) {
        foreach ($input.array_7) {
          each as $item {
            array.push $array {
              value = $item
            }
          }
        }
      }
    
      else {
        array.push $array {
          value = $input.array_7
        }
      }
    }
  
    conditional {
      if (($input.array_8|is_array) === true) {
        foreach ($input.array_8) {
          each as $item {
            array.push $array {
              value = $item
            }
          }
        }
      }
    
      else {
        array.push $array {
          value = $input.array_8
        }
      }
    }
  
    conditional {
      if (($input.array_9|is_array) === true) {
        foreach ($input.array_9) {
          each as $item {
            array.push $array {
              value = $item
            }
          }
        }
      }
    
      else {
        array.push $array {
          value = $input.array_9
        }
      }
    }
  }

  response = $array
}