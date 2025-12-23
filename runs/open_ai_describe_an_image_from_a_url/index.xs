// # Function Documentation: OpenAI -> Describe an Image from a URL (Simple)
// [OpenAI Vision API](https://platform.openai.com/docs/guides/vision)
// ## Overview
// This function generates a description of an image using the OpenAI API based on the provided image URL. It requires parameters such as the image URL & model. The function ensures necessary environment variables are set and verifies conditions before making the API request and processing the response.
// 
// ## Inputs
// 1. **openai_api_key** (registry|text) *Required* *Sensitive data*
//    - **Description:** The API key for your OpenAI account.
// 
// 1. **image_url** (text) *Required*
//    - **Description:** The URL of the image that will be sent to the OpenAI API for generating the description.
// 
// 2. **model** (enum) *Required*
//    - **Description:** Specifies the model to be used for generating the image description.
//    - **Options:** 
//       - `gpt-4o-mini` *(default)*
//       - `gpt-4o` 
// 
// ## Function Stack
// ### 1. OpenAI API Request
// 1. **API Request to `https://api.openai.com`**
//    - **Purpose:** Sends a request to the OpenAI API using the specified model and image URL.
// 
// 2. **Precondition: `openai_api_response.status == 200`**
//    - **Purpose:** Confirms that the API request was successful (HTTP status code 200).
// 
// ### 2. OpenAI API Response
// 1. **Create Variable: `response`**
//    - **Purpose:** Stores the response from the OpenAI API.
// 
// ## Response
// - The function returns the generated image description, optionally including token usage details if the `show_token_usage` flag is set to true.
// 
// ### Success response
// ```json
// {
//    "The image depicts a model or miniature of a fortified castle or walled city. It features a large structure at the top, resembling a castle, with walls and towers surrounding smaller buildings that likely represent a village or town inside the fortifications. The overall layout suggests a historical or fantasy setting, commonly seen in architectural models or films."
// }
// ```
// ### Error response
// ```json 
// {
//   "message":"Invalid image."
// } 
// ```
// 
// 
// 
// ## Example
// **Input**
// ```json
// {
//   "image_url": "https://upload.wikimedia.org/wikipedia/commons/b/b7/Medieval_Durr%C3%ABs.jpg",
//   "model": "gpt-4o-mini",
// }
// ```
// **Response**
// ```json
// {
//    "The image depicts a model or miniature of a fortified castle or walled city. It features a large structure at the top, resembling a castle, with walls and towers surrounding smaller buildings that likely represent a village or town inside the fortifications. The overall layout suggests a historical or fantasy setting, commonly seen in architectural models or films."
// }
// 
// ```
function "OpenAI -> Describe an Image from a URL" {
  input {
    text image_url? filters=trim|pattern:"(?i)^https?:\\/\\/[^\\s]+?\\.(jpg|jpeg|png|gif|bmp|webp)$":"Whoops, the input parameter image_url is invalid :-(!"
  
    // The model from OpenAI to use
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
            |set:"model":"gpt-4o-mini"
            |set:"messages":([]
              |push:({}
                |set:"role":"user"
                |set:"content":([]
                  |push:({}
                    |set:"type":"text"
                    |set:"text":"What’s in this image?"
                  )
                  |push:({}
                    |set:"type":"image_url"
                    |set:"image_url":({}|set:"url":$input.image_url)
                  )
                )
              )
            )
            |set:"max_tokens":300
          headers = []
            |push:"Content-Type: application/json"
            |push:("Authorization: Bearer %s"|sprintf:$reg.openai_api_key)
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
          value = {}
            |set:"status":"ok"
            |set:"message":"Image description generated successfully! :-)"
            |set:"data":$openai_api.response.result.choices.0.message.content
        }
      }
    }
  }

  response = $response
  tags = ["openai"]
}