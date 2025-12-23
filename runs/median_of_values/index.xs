function median {
  input {
    decimal[] values
  }

  stack {
    var $sorted {
      value = $input.values|sort:"":"number":true
    }
  
    var $size {
      value = $input.values|count
    }
  
    var $median_index {
      value = $size|divide:2|floor
    }
  
    conditional {
      if ($size > 1) {
        conditional {
          if (($size|modulus:2) === 0) {
            return {
              value = ```
                (
                  ($var.sorted|get:$var.median_index) + 
                  ($var.sorted|get:$var.median_index+1)
                )|divide: 2
                ```
            }
          }
        
          else {
            return {
              value = `$var.sorted`|get:$median_index:null
            }
          }
        }
      }
    }
  }

  response = $var.sorted[0]
}