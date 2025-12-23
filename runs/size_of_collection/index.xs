workspace size_of_collection
---
function "$main" {
  input {
    object args {
      schema {
        // The collection to inspect
        json collection?
      }
    }
  }

  stack {
    conditional {
      if (($input.collection|is_array) === true) {
        return {
          value = $input.collection|count
        }
      }
    }
  
    conditional {
      if (($input.collection|is_text) === true) {
        return {
          value = $input.collection|strlen
        }
      }
    }
  
    conditional {
      if (($input.collection|is_object) === true) {
        return {
          value = $input.collection|values|count
        }
      }
    }
  }

  response = 0
}