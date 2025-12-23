// This function summarizes a piece of text using the OpenAI API
function "OpenAI -> Summarize (Simple)" {
  input {
    text input_text filters=trim
    enum model?="gpt-4o-mini" {
      values = ["gpt-4o", "gpt-4o-mini", "gpt-4-turbo"]
    }
  }

  stack {
    // OpenAI API Request
    group {
      stack {
        api.request {
          url = "https://api.openai.com/v1/chat/completions"
          method = "POST"
          params = {}
            |set:"model":$input.model
            |set:"messages":([]
              |push:({}
                |set:"role":"system"
                |set:"content":"You are a helpful assistant."
              )
              |push:({}
                |set:"role":"user"
                |set:"content":("Please summarize the following text: %s"|sprintf:$input.input_text)
              )
            )
          headers = []
            |push:"Content-Type: application/json"
            |push:("Authorization: Bearer %s"
              |sprintf:("openai_api_key"|!get:"openai_api_key":null)
            )
        } as $openai_api
      }
    }
  
    precondition ($openai_api.response.status == 200) {
      error = $openai_api.response.result.error.message
    }
  
    // OpenAI API Response Content
    group {
      stack {
        var $response {
          value = $openai_api.response.result.choices.0.message.content
        }
      }
    }
  }

  response = $response
  tags = ["openai"]
}