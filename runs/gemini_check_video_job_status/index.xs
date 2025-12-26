run.job "Gemini -> Check Video Job Status" {
  main = {
    name : "Gemini -> Check Video Job Status"
    input: {
      name: "models/veo-3.0-generate-preview/operations/abcd1234"
    }
  }

  env = ["gemini_api_key"]
}
---
function "Gemini -> Check Video Job Status" {
  input {
    text name filters=trim
  }

  stack {
    // Gemini API
    group {
      stack {
        api.request {
          url = "https://generativelanguage.googleapis.com/v1beta/%s"|sprintf:$input.name
          method = "GET"
          headers = []
            |push:("x-goog-api-key: %s"|sprintf:$env.gemini_api_key)
        } as $gemini_api
      }
    }
  
    precondition ($gemini_api.response.status == 200) {
      error = "Uh oh, we've run into an error. Response code: %s"
        |sprintf:$gemini_api.response.status
    }
  }

  response = $gemini_api.response.result
}