run.job "OpenAI -> Create an image" {
  main = {name: "OpenAI -> Create an image", input: {}}
  env = ["openai_api_key"]
}
---
// This function creates an image from an input text using the OpenAI API
function "OpenAI -> Create an image" {
  input {
    text prompt filters=trim
  
    // The dimensions of the generated image
    enum img_size?=1024x1024 {
      values = ["1024x1024", "1024x1792", "1792x1024"]
    }
  
    enum model?="dall-e-3" {
      values = ["dall-e-3", "dall-e-2"]
    }
  }

  stack {
    // OpenAI API Request
    group {
      stack {
        api.request {
          url = "https://api.openai.com/v1/images/generations"
          method = "POST"
          params = {}
            |set:"model":$input.model
            |set:"prompt":$input.prompt
            |set:"n":1
            |set:"size":$input.img_size
          headers = []
            |push:"Content-Type: application/json"
            |push:("Authorization: Bearer %s"|sprintf:$env.openai_api_key)
          timeout = 60
        } as $openai_api
      }
    }
  
    precondition ($openai_api.response.status == 200) {
      error = $openai_api.response.result.error.message
    }
  
    // OpenAI API Response
    group {
      stack {
        var $response {
          value = $openai_api.response.result.data.0.url
        }
      }
    }
  }

  response = $response
  tags = ["openai"]
}