workspace slack_send_channel_message {
  env = {slack_token: ""}
}
---
// # Function Documentation: Slack -> Send Channel Message
// ## Overview
// This function sends a message to a specified Slack channel using the Slack API. It uses a pre-configured Slack token from the environment to authenticate the request and sends a message to the channel based on user inputs.
// ## Inputs
// 1. **`slack_token`** (registry|text) *Required*
//    - **Purpose:** The ID of the Slack channel where the message will be sent.
// 2. **`channel_id`** (text) *Required*
//    - **Purpose:** The ID of the Slack channel where the message will be sent.
// 3. **`message`** (text) *Required*
//    - **Purpose:** The content of the message to be sent to the Slack channel.
// ## Function Stack
// ### 1. API Request to Slack
// - **Endpoint:** `https://slack.com/api/chat.postMessage`
//    - **Method:** `POST`
//    - **Parameters:**
//      - `channel`: The Slack channel ID (`channel_id` input).
//      - `text`: The message content (`message` input).
//    - **Headers:**
//      - `Authorization`: Bearer `slack_token`
//    - **Purpose:** Sends a message to the specified Slack channel using the Slack API.
// ### 2. Create Variable: `response`
// - **Variable:** `var: response = var: api_response.response.result`
//    - **Purpose:** Stores the response from the Slack API after sending the message.
// ## Response
// - The function returns the response from Slack, which contains information about the message and its status.
// ### Success Response
// ```json
// {
//    {
//   "ok": true,
//   "channel": "C07983****",
//   "ts": "1728480204.015929",
//   "message": {
//     "user": "U06UJRZ****",
//     "type": "message",
//     .
//     .
//     .
//   }
// }
// }
// ```
// ### Error response
// ```json
// {
//   "ok": false,
//   "error": "channel_not_found"
// }
// ```
// ## Example
// ### Input
//     ```json
//     {
//       "channel_id": "C01A*****",
//       "message": "Hello, Slack channel!"
//     }
//     ```
// ### Output
// ```json
// {
//    {
//   "ok": true,
//   "channel": "C07983****",
//   "ts": "1728480204.015929",
//   "message": {
//     "user": "U06UJRZ****",
//     "type": "message",
//     .
//     .
//     .
//   }
// }
// }
// ```
function "Slack -> Send Channel Message" {
  input {
    text channel_id filters=trim
    text message filters=trim
  }

  stack {
    // Slack API Request
    group {
      stack {
        api.request {
          url = "https://slack.com/api/chat.postMessage"
          method = "POST"
          params = {}
            |set:"text":$input.message
            |set:"channel":$input.channel_id
          headers = []
            |push:("Authorization: Bearer"|concat:$env.slack_token:" ")
        } as $api_response
      }
    }
  
    // Response variable
    group {
      stack {
        var $response {
          value = $api_response.response.result
        }
      }
    }
  }

  response = $response
}