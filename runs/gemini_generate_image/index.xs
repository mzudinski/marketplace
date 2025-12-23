workspace gemini_generate_image {
  env = {gemini_api_key: ""}
}
---
function "Gemini -> Generate Image" {
  input {
    text model?="gemini-2.0-flash-preview-image-generation" filters=trim
    text prompt? filters=trim
  }

  stack {
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
                  |push:({}|set:"text":$input.prompt)
                )
              )
            )
            |set:"generationConfig":({}
              |set:"responseModalities":([]|push:"TEXT"|push:"IMAGE")
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
  
    storage.create_file_resource {
      filename = "image_response.png"
      filedata = $gemini_api.response.result.candidates.0.content.parts.1.inlineData.data
    } as $file1
  }

  response = $gemini_api.response.result
}