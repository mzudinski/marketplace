function "Optimize AI Input" {
  input {
    json payload?
  
    // This will remove any empty keys to reduce token usage
    bool strip_empty_keys?
  }

  stack {
    // Ensure that the input payload is not null.
    precondition ($input.payload != null) {
      error_type = "inputerror"
      error = "Payload cannot be null. Please provide a JSON object."
    }
  
    // Initialize an empty object to store the payload with non-empty keys.
    var $cleaned_payload {
      value = {}
    }
  
    foreach ($input.payload|entries) {
      each as $entry {
        // Check if the value is considered empty (null, empty string, empty array, or empty object).
        var $is_empty_value {
          value = ($entry.value == null) || (($entry.value|is_text) && ($entry.value|strlen) == 0) || (($entry.value|is_array) && ($entry.value|count) == 0) || (($entry.value|is_object) && ($entry.value|count) == 0)
        }
      
        conditional {
          if ($is_empty_value == false) {
            // Add non-empty key-value pair to the cleaned payload.
            var.update $cleaned_payload {
              value = $cleaned_payload|set:$entry.key:$entry.value
            }
          }
        }
      }
    }
  
    // Encode the cleaned payload to a JSON string, serving as the YAML output approximation.
    var.update $cleaned_payload {
      value = $cleaned_payload|yaml_encode
    }
  }

  response = $cleaned_payload
}