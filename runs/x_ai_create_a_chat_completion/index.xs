run "xAI -> Completion" {
  type = "job"
  main = {
    name : "xAI -> Completion"
    input: {
      model  : "grok-beta"
      message: "Give me a spicy take on the current 2024 presidential election? Use x posts as sources"
      system : "You are Grok, a chatbot inspired by the Hitchhikers Guide to the Galaxy."
    }
  }

  env = ["xai_api_key"]
}
---
// # Function Documentation: xAI -> Create a Chat Completion
// 
// [xAI API documentation](https://docs.x.ai/api/endpoints#completions)
// 
// ## Overview
// This function generates a completion using the xAI API based on a user-provided prompt. It requires parameters such as the model & prompt text. The function validates environment variables and conditions before making an API request and processing the response.
// 
// ## Inputs
// 1. **xai_api_key** (registry|text) *Required* *Sensitive data*
//    * **Description:** The API key for your xAI account.
// 2. **model** (enum) *Required*
//    * **Description:** Specifies the model to be used for generating the completion.
//    * **Options:**
//       * Available models will be specified by xAI
// 3. **message** (text) *Required*
//    * **Description:** The input prompt that will be sent to the xAI API for generating the completion.
// 4. **system** (text) *Required*
//    * **Description:** The input system helps give the AI further specific instructions about how you wish the AI to respond.
// 
// ## Function Stack
// ### 1. xAI API Request
// 1. **API Request to** `https://api.x.ai/v1/completions`
//    * **Purpose:** Sends a request to the xAI API using the specified model and prompt.
// 2. **Precondition:** `xai_api_response.status == 200`
//    * **Purpose:** Confirms that the API request was successful (HTTP status code 200).
// 
// ### 2. xAI API Response
// 1. **Create Variable:** `response`
//    * **Purpose:** Stores the response from the xAI API.
// 
// ## Response
// * The function returns the generated completion in a structured format
// 
// ### Success Response
// Response provided as a string.
// 
// ### Error Response
// ```json
// {
//   "error": {
//     "message": "Invalid API key provided",
//     "type": "invalid_request_error"
//   }
// }
// ```
// 
// ## Example
// ### Input
// ```json
// {
//   "model": "grok-beta",
//   "prompt": "What is Obama's height?"
// }
// ```
// 
// ### Response
// ```
// "Barack Obama is 6 feet 1 inch tall (185 cm)."  
// ```
function "xAI -> Completion" {
  input {
    text model?="grok-beta" filters=trim
    text message? filters=trim
    text system?="You are Grok, a chatbot inspired by the Hitchhikers Guide to the Galaxy." filters=trim
  }

  stack {
    // xAI API Request
    group {
      stack {
        api.request {
          url = "https://api.x.ai/v1/chat/completions"
          method = "POST"
          params = {}
            |set:"model":$input.model
            |set:"messages":([]
              |push:({}
                |set:"role":"system"
                |set:"content":$input.system
              )
              |push:({}
                |set:"role":"user"
                |set:"content":$input.message
              )
            )
          headers = []
            |push:"Content-Type: application/json"
            |push:("Authorization: Bearer %s"|sprintf:$env.xai_api_key)
          timeout = 60
        } as $xai_api
      
        precondition ($xai_api.response.status == 200) {
          error = $xai_api.response.result.error
        }
      }
    }
  
    // xAI API Response
    group {
      stack {
        var $response {
          value = $xai_api.response.result.choices.0.message.content
        }
      }
    }
  }

  response = $response
}