run "Google Maps -> Places Details" {
  type = "job"
  main = {
    name : "Google Maps -> Places Details"
    input: {
      place_id     : "ChIJN1t_tDeuEmsRUsoyG83frY4"
      field_mask   : "displayName,formattedAddress,internationalPhoneNumber,website"
      language_code: "en"
      session_token: "adf1234bc-5678-91de-0000-abc123456def"
    }
  }

  env = ["google_api_key"]
}
---
function "Google Maps -> Places Details" {
  input {
    text place_id filters=trim
    text field_mask? filters=trim
    text language_code? filters=trim
    text session_token? filters=trim
  }

  stack {
    // Prepare field_mask param
    group {
      stack {
        var $field_mask {
          value = ($input.field_mask|is_empty) ? "displayName,formattedAddress" : $input.field_mask
        }
      }
    }
  
    // Google Maps API
    group {
      stack {
        api.request {
          url = "https://places.googleapis.com/v1/places/%s"|sprintf:$input.place_id
          method = "GET"
          params = {}
            |set_conditional:"languageCode":$input.language_code:(($input.language_code|is_empty)|not)
            |set_conditional:"sessionToken":$input.session_token:(($input.session_token|is_empty)|not)
          headers = []
            |push:"Content-Type: application/json"
            |push:("X-Goog-Api-Key: %s"|sprintf:$env.google_api_key)
            |push:("X-Goog-FieldMask: %s"|sprintf:$field_mask)
        } as $gmaps_api
      }
    }
  
    precondition ($gmaps_api.response.status == 200) {
      error = "Uh oh, Google Maps API responded with a %s. Error message: %s"
        |sprintf:$gmaps_api.response.status:$gmaps_api.response.result.error.status
    }
  }

  response = $gmaps_api.response.result
}