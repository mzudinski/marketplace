// # WhatsApp API → Send Message via WhatsApp
// ## Overview
// This function allows you to send a WhatsApp message using the WhatsApp API by calling the Facebook Graph API. You can specify the recipient's phone number and the message content, and the function will handle sending the message to the recipient.
// ## Inputs
// 1. **whatsapp_account_id** (registry/text) *Required*
//    - **Description:** The WhatsApp account ID associated with the message-sending feature.
//    - **Example:** `1234567890`
// 2. **whatsapp_token** (registry/text) *Required*
//    - **Description:** The token or authentication key to authenticate the API request to WhatsApp.
//    - **Example:** `EAAkfsidlfjsdflslkn...`
// 3. **to_number** (text) *Required*
//    - **Description:** The recipient's phone number in international format (without '+' or '00'). For example, a US phone number would be entered as `11234567890`.
//    - **Example:** `11234567890`
// 4. **message** (text) *Required*
//    - **Description:** The content of the message that will be sent to the recipient.
//    - **Example:** `Hello, this is a test message from our service!`
// 5. **version** (text) *Required*
//    - **Description:** The API version to use when making the request to the WhatsApp Graph API.
//    - **Example:** `v2.8`
// ## Function Stack
// ### 1. API Request to WhatsApp API
//    - **API Request To:** `https://graph.facebook.com/{version}/{whatsapp_account_id}/messages`
//    - **Method:** POST
//    - **Headers:**
//      - `Authorization: Bearer {whatsapp_token}`
//    - **Body:**
//    ```json
//    {
//     "messaging_product" : "whatsapp",
//     "recipient_type" : "individual",
//     "to": "+9183277*****",
//     "type": "text",
//     "text": {
//         "preview_url": false,
//         "body": "Hello World"
//     }
//   }
//    ```
//    - **Purpose:** Sends a POST request to the WhatsApp API with the recipient's phone number and the message to be delivered.
// ### 2. Create Variable: `response`
// - **Variable:** `var: response = var: api_response.response.result`
//    - **Purpose:** Stores the response from the Whatsapp API after sending the message.
// ## Response
// - The function returns the result from the WhatsApp API.
// ### Success Response
// ```json
// {
//     "messaging_product": "whatsapp",
//     "contacts": [
//         {
//             "input": "+9183277*****",
//             "wa_id": "91832770*****"
//         }
//     ],
//     "messages": [
//         {
//             "id": "wamid.HBgMOTE4MzI3N**********"
//         }
//     ]
// }
// ```
// ### Error response
// ```json
// {
//   "success": false,
//   "error_code": 401,
//   "message": "Unauthorized: Invalid or missing API token."
// }
// ```
// ## Example
// ### Input
// ```json
// {
//     "messaging_product" : "whatsapp",
//     "recipient_type" : "individual",
//     "to": "+9183277*****",
//     "type": "text",
//     "text": {
//         "preview_url": false,
//         "body": "Hello World"
//     }
// }
// ```
// ### Output
// ```json
// {
//     "messaging_product": "whatsapp",
//     "contacts": [
//         {
//             "input": "+918327*****",
//             "wa_id": "9183277*****"
//         }
//     ],
//     "messages": [
//         {
//             "id": "wamid.HBgMOTE4MzI3N**********"
//         }
//     ]
// }
// ```
function "Whatsapp -> Send Message" {
  input {
    text to_number filters=trim
    text message filters=trim
    text version filters=trim
  }

  stack {
    // Whatsapp API Call
    group {
      stack {
        api.request {
          url = "https://graph.facebook.com/%s/%s/messages"
            |sprintf:$input.version:$reg.whatsapp_account_id
          method = "POST"
          params = {}
            |set:"messaging_product":"whatsapp"
            |set:"recipient_type":"individual"
            |set:"to":$input.to_number
            |set:"type":"text"
            |set:"text":({}
              |set:"preview_url":true
              |set:"body":$input.message
            )
          headers = []
            |push:"Content-Type: application/json"
            |push:("Authorization: Bearer %s"|sprintf:$reg.whatsapp_token)
        } as $api_response
      }
    }
  
    // Response
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