workspace gemini_generate_video {
  env = {gemini_api_key: ""}
}
---
function "$main" {
  input {
    object args {
      schema {
        text model?="veo-3.0-generate-preview:predictLongRunning" filters=trim
        text prompt? filters=trim
        enum aspect_ratio?="16:9" {
          values = ["16:9", "9:16"]
        }
      
        enum person_generation?="allow_all" {
          values = ["dont_allow", "allow_adult", "allow_all"]
        }
      }
    }
  }

  stack {
    // Gemini API request
    group {
      stack {
        api.request {
          url = "https://generativelanguage.googleapis.com/v1beta/models/%s"|sprintf:$input.model
          method = "POST"
          params = {}
            |set:"instances":([]
              |push:({}|set:"prompt":$input.prompt)
            )
            |set:"parameters":({}
              |set:"aspectRatio":$input.aspect_ratio
              |set:"personGeneration":$input.person_generation
              |!set:"durationSeconds":$input.duration_seconds
            )
          headers = []
            |push:("x-goog-api-key: %s"|sprintf:$env.gemini_api_key)
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