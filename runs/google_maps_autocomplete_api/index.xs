run "Google Maps -> Autocomplete API" {
  type = "job"
  main = {
    name : "Google Maps -> Autocomplete API"
    input: {
      input      : "221B Baker Street"
      latitude   : "51.5237"
      longitude  : "-0.1585"
      radius     : 500
      region_code: "gb"
    }
  }

  env = ["google_api_key"]
}
---
function "Google Maps -> Autocomplete API" {
  input {
    text input filters=trim
    text session_token? filters=trim
    text field_mask? filters=trim
    text latitude? filters=trim
    text longitude? filters=trim
    int radius?
    text region_code? filters=trim
  }

  stack {
    // Prepare field_mask param
    group {
      stack {
        var $field_mask {
          value = ($input.field_mask|is_empty) ? "*" : $input.field_mask
        }
      }
    }
  
    // Prepare session token
    group {
      stack {
        var $session_token {
          value = ($input.session_token|is_empty) ? (|uuid) : $input.session_token
        }
      }
    }
  
    api.request {
      url = "https://places.googleapis.com/v1/places:autocomplete"
      method = "POST"
      params = {}
        |set:"input":$input.input
        |set_conditional:"locationBias":({}
          |set:"circle":({}
            |set:"center":({}
              |set:"latitude":$input.latitude
              |set:"longitude":$input.longitude
            )
          )
          |set:"radius":$input.radius
        ):(($input.latitude|is_empty)|not)
        |set:"sessionToken":$session_token
        |set_conditional:"regionCode":$input.region_code:(($input.region_code|is_empty)|not)
      headers = []
        |push:"Content-Type: application/json"
        |push:("X-Goog-Api-Key: %s"|sprintf:$env.google_api_key)
        |push:("X-Goog-FieldMask: %s"|sprintf:$field_mask)
    } as $gmaps_api
  
    precondition ($gmaps_api.response.status == 200 && ($gmaps_api.response.result|get:"error_message":null) == null) {
      error = "Uh oh, Google Maps API responded with a %s. Error message: %s"
        |sprintf:$gmaps_api.response.status:($gmaps_api.response.result|get:"error.status":null)
    }
  }

  response = {
    api_response : $gmaps_api.response.result
    session_token: $session_token
  }
}