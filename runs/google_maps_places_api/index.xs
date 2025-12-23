function "Gmaps test" {
  input {
    text query filters=trim
    text field_mask? filters=trim
    text language_code? filters=trim
    text page_token? filters=trim
    int page_size?
    json location_bias?
  }

  stack {
    // Prepare field_mask param
    group {
      stack {
        var $field_mask {
          value = ($input.field_mask|is_empty) ? "places.displayName,places.formattedAddress,places.priceLevel,nextPageToken" : $input.field_mask
        }
      }
    }
  
    // Google Maps API
    group {
      stack {
        api.request {
          url = "https://places.googleapis.com/v1/places:searchText"
          method = "POST"
          params = {}
            |set:"textQuery":$input.query
            |set_conditional:"pageSize":$input.page_size:($input.page_size|is_empty|not)
            |set_conditional:"pageToken":$input.page_token:($input.page_token|is_empty|not)
            |set_conditional:"languageCode":$input.language_code:($input.language_code|is_empty|not)
            |set_conditional:"locationBias":$input.location_bias:($input.location_bias|is_empty|not)
          headers = []
            |push:"Content-Type: application/json"
            |push:("X-Goog-Api-Key: %s"|sprintf:"google_key")
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