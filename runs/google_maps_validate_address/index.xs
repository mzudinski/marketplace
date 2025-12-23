workspace google_maps_validate_address {
  env = {google_api_key: ""}
}
---
function "Google Maps -> Validate Address" {
  input {
    text region_code? filters=trim
    text address_lines filters=trim
    text language_code?=en filters=trim
    text session_token? filters=trim
  }

  stack {
    // Google Maps API
    group {
      stack {
        api.request {
          url = "https://addressvalidation.googleapis.com/v1:validateAddress"
          method = "POST"
          params = {}
            |set:"address":({}
              |set:"regionCode":"US"
              |set:"addressLines":([]
                |push:"1600 Amphitheatre Parkway, Mountain View, CA"
              )
            )
          headers = []
            |push:"Content-Type: application/json"
            |push:("X-Goog-Api-Key: %s"|sprintf:$env.google_api_key)
        } as $gmaps_api
      }
    }
  
    precondition ($gmaps_api.response.status == 200) {
      error = "Uh oh, the Google Maps API returned an error %s"
        |sprintf:$gmaps_api.response.status
    }
  }

  response = $gmaps_api.response.result
}