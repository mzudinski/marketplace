function "Google Maps -> Reverse Geocode" {
  input {
    text latitude filters=trim
    text longitude? filters=trim
  }

  stack {
    // Google Maps API
    group {
      stack {
        api.request {
          url = "https://maps.googleapis.com/maps/api/geocode/json"
          method = "GET"
          params = {}
            |set:"latlng":($input.latitude|concat:$input.longitude:",")
            |set:"key":$reg.google_api_key
        } as $gmaps_api
      }
    }
  
    precondition ($gmaps_api.response.status == 200 && ($gmaps_api.response.result|get:"error_message":null) == null) {
      error = "Uh oh, Google Maps API responded with a %s. Error message: %s"
        |sprintf:$gmaps_api.response.status:($gmaps_api.response.result|get:"error.status":null)
    }
  }

  response = $gmaps_api.response.result
}