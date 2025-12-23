workspace gemini_image_understanding {
  env = {gemini_api_key: ""}
}
---
function "$main" {
  input {
    text model?="gemini-2.0-flash" filters=trim
    text prompt? filters=trim
    file? image
  }

  stack {
    // Create file resource from image
    group {
      stack {
        storage.read_file_resource {
          value = $input.image
        } as $file_raw
      }
    }
  
    // Gemini API request
    group {
      stack {
        api.request {
          url = "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s"
            |sprintf:$input.model:$env.gemini_api_key
          method = "POST"
          params = {}
            |set:"contents":([]
              |push:({}
                |set:"parts":([]
                  |push:({}
                    |set:"inline_data":({}
                      |set:"mime_type":"image/jpeg"
                      |set:"data":($file_raw.data|base64_encode)
                    )
                  )
                  |push:({}|set:"text":$input.prompt)
                )
              )
            )
          headers = []
            |push:"Content-Type: application/json"
          timeout = 60
        } as $gemini_api
      }
    }
  
    precondition ($gemini_api.response.status == 200) {
      error = "Uh oh! The Gemini API responded with an error: %s"
        |sprintf:($gemini_api.response.result
          |get:"error":null
          |get:"message":null
        )
    }
  }

  response = $gemini_api.response.result
}