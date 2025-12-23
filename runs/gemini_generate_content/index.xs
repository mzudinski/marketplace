workspace gemini_generate_content {
  env = {gemini_api_key: ""}
}
---
function "Gemini -> Generate Content" {
  input {
    text model?="gemini-2.0-flash" filters=trim
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