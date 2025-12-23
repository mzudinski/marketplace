workspace open_ai_create_a_chat_completion {
  env = {openai_api_key: ""}
}
---
// # Function Documentation: OpenAI -> Create a Chat Completion (Hybrid)
// [OpenAI API documentation](https://platform.openai.com/docs/guides/chat-completions)
// ## Overview
// This function generates a chat completion using the OpenAI API based on a user-provided input text. It requires parameters such as the model & input message. The function validates environment variables and conditions before making an API request and processing the response.
// 
// ## Inputs
// 1. **openai_api_key** (registry|text) *Required* *Sensitive data*
//    - **Description:** The API key for your OpenAI account.
// 
// 2. **model** (enum) *Required*
//    - **Description:** Specifies the model to be used for generating the chat completion.
//    - **Options:** 
//         - `gpt-4o-mini` *(default)*
//         - `gpt-4o`  
// 
// 3. **message** (text) *Required*
//    - **Description:** The input message or prompt that will be sent to the OpenAI API for generating the chat completion.
// 
// ## Function Stack
// ### 1. OpenAI API Request
// 1. **API Request to `https://api.openai.com`**
//    - **Purpose:** Sends a request to the OpenAI API using the specified model and message.
// 
// 2. **Precondition: `openai_api_response.status == 200`**
//    - **Purpose:** Confirms that the API request was successful (HTTP status code 200).
// 
// ### 2. OpenAI API Response
// 1. **Create Variable: `response`**
//    - **Purpose:** Stores the response from the OpenAI API.
// 
// ## Response
// - The function returns the generated chat completion
// 
// ### Success response
// ```json
// {
//    "Barack Obama is 6 feet 1 inch tall (185 cm)."
// }
// ```
// ### Error response
// ```json
// {
//   "message": "Incorrect API key provided: ssk-None*********************************************GQPD. You can find your API key at https://platform.openai.com/account/api-keys."
// }
// ```
// 
// ## Example
// **Input**
// ```json
// {
//   "model": "gpt-4o-mini",
//   "message": "What is Obama's height?"
// }
// ```
// 
// **Response**
// ```json
// {
//    "Barack Obama is 6 feet 1 inch tall (185 cm)."
// }
// ```
function "$main" {
  input {
    object args {
      schema {
        enum model?="gpt-4o-mini" {
          values = ["gpt-4o-mini", "gpt-4o"]
        }
      
        text message filters=trim
      }
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
                |set:"content":$input.message
              )
            )
          headers = []
            |push:"Content-Type: application/json"
            |push:("Authorization: Bearer %s"|sprintf:$env.openai_api_key)
          timeout = 60
        } as $openai_api
      
        precondition ($openai_api.response.status == 200) {
          error = $openai_api.response.result.error.message
        }
      }
    }
  
    // OpenAI API Response
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