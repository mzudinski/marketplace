workspace is_match
---
// Performs a partial deep comparison between `object` and `source` to determine if `object` contains equivalent property values.
function isMatch {
  input {
    json object?
    json props?
  }

  stack {
    conditional {
      if (($input.object|is_object) && ($input.props|is_object)) {
        foreach ($input.props|keys) {
          each as $key {
            action.call "" {
              package = ""
              input = {
                object: $input.object|get:$key:null
                props : $input.props|get:$key:null
              }
            } as $is_match
          
            conditional {
              if ($is_match == false) {
                return {
                  value = false
                }
              }
            }
          }
        }
      }
    
      elseif (($input.object|is_array) && ($input.props|is_array)) {
        foreach ($input.props) {
          each as $props_item {
            var $match_current_prop {
              value = false
            }
          
            foreach ($input.object) {
              each as $object_item {
                action.call "" {
                  package = ""
                  input = {object: $object_item, props: $props_item}
                } as $is_match
              
                conditional {
                  if ($is_match) {
                    var.update $match_current_prop {
                      value = true
                    }
                  
                    break
                  }
                }
              }
            }
          
            conditional {
              if ($match_current_prop == false) {
                return {
                  value = false
                }
              }
            }
          }
        }
      }
    
      elseif (($input.object|is_object) && ($input.props|is_text)) {
        action.call "" {
          package = ""
          input = {array: $input.object, key: $input.props}
        } as $is_match
      
        return {
          value = ($var.is_match|first) ? true : false
        }
      }
    
      elseif ($input.object == $input.props) {
        return {
          value = true
        }
      }
    
      else {
        return {
          value = false
        }
      }
    }
  }

  response = true
}