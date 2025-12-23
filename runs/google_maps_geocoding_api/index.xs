function "Google Maps -> Geocoding API" {
  input {
    text address filters=trim
    text region? filters=trim
  }

  stack {
    // Google Maps API
    group {
      stack {
        api.request {
          url = "https://maps.googleapis.com/maps/api/geocode/json"
          method = "GET"
          params = {}
            |set:"address":$input.address
            |set:"key":$reg.google_api_key
            |set_conditional:"region":$input.region:($input.region|is_empty|not)
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