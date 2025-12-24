run "Concat array" {
  type = "job"
  main = {
    name : "Concat array"
    input: {
      array_1: [1, 2, 3]
      array_2: 12
      array_3: []
      array_4: []
      array_5: []
      array_6: "foo"
      array_7: []
      array_8: true
      array_9: {}
    }
  }
}
---
function "Concat array" {
  input {
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