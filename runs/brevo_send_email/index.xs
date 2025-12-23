// # Function Documentation: Brevo → Send Single Email
// [Brevo API documentation](https://developers.brevo.com/docs/getting-started)
// 
// 
// ## Overview
// This function sends a single email using the Brevo (Sendinblue) API with HTML content. It requires inputs such as the API key, sender and receiver details, email content, and subject. The function validates and processes the input before making a request to the Brevo API.
// 
// ## Inputs
// 
// 1. **brevo_api_key** (registry/text) *Required*
//    - **Description:** API key for authenticating with Brevo API.
//    - **Example:** `xkeysib-...`
// 
// 2. **from** (object) *Required*
//    - **Description:** The sender's email address.
//    - **Example:** `sender@example.com`
// 
// 3. **to** (object) *Required*
//    - **Description:** The recipient's email address.
//    - **Example:** `receiver@example.com`
// 
// 4. **message_html** (text) *Required*
//    - **Description:** The HTML content to be sent.
//    - **Example:** `<html><body><h1>Hello</h1></body></html>`
// 
// 5. **subject** (text) *Required*
//    - **Description:** The subject of the email.
//    - **Example:** `Welcome to our service!`
// 
// ## Function Stack
// 
// ### 1. Try / Catch Block
// 
// #### 1. Precondition: Check Valid HTML Content
//    - **Description:** Ensures the HTML content for the email is valid before proceeding.
// 
// #### 2. API Request to Sendinblue
// 1. **API Request to `https://api.brevo.com/v3/smtp/email`**
//    - **Purpose:** Sends the email using the Brevo (Sendinblue) API.
//    - **Return Value:** The API response is stored as `api_response`.
// 
// #### 3. Create Variable: `response`
//    - **Variable:** `var: response = var: api_response.response.result` 
//    - **Purpose:** Stores the API response for the SMS send operation.
// 
// ### 2 Error Handling (Catch)
// 
// 1. **Create Variable: `response`**
//    - **Purpose:** If the API call fails or returns an error, this block catches the error and provides an error message.
// 
// ## Response
// 
// The function returns the result of the email send operation, including status and any relevant messages.
// 
// ### Success Response
// ```json
// {
//   "messageId": "<202410100***.1236169****@smtp-relay.mailin.fr>",
// }
// ```
// 
// ### Error response
// 
// ```json
// {
// 
//   "message": "Key not found",
//   "code": "unauthorized"
// 
// }
// ```
// 
// ## Example
// 
// ### Input
// ```json
// {
//     "from":{
//         "from_name":"John",
//         "from_email":"sohansakhare****@gmail.com"
//     },
//     "to":{
//         "to_name":"David",
//         "to_email":"sajankumar.****@unicoco****.com"
//     },
//     "email_html":"<html><head></head><body><p>Hello world</p></body></html>",
//     "subject":"abc"
// }
// ```
// 
// ### Output
// ```json
// {
//   "messageId": "<202410100***.1236169****@smtp-relay.mailin.fr>"
// }
// ```
function "Brevo -> Send Email" {
  input {
    object from {
      schema {
        text name filters=trim
        email email filters=trim|lower
      }
    }
  
    object to {
      schema {
        text name filters=trim
        email email filters=trim|lower
      }
    }
  
    text message_html filters=trim
    text subject filters=trim
  }

  stack {
    try_catch {
      try {
        // Validation for valid html message
        precondition ("/^<([a-z]+)([^<]+)*(?:>(.*)<\\/\\1>|\\s+\\/>)$/"|regex_matches:$input.message_html) {
          error_type = "badrequest"
          error = "Message HTML not in valid format."
        }
      
        // Brevo API request
        api.request {
          url = "https://api.brevo.com/v3/smtp/email"
          method = "POST"
          params = {}
            |set:"sender":({}
              |set:"name":$input.from.name
              |set:"email":$input.from.email
            )
            |set:"to":([]
              |push:({}
                |set:"email":$input.to.email
                |set:"name":$input.to.name
              )
            )
            |set:"subject":$input.subject
            |set:"htmlContent":$input.message_html
          headers = []
            |push:"accept: application/json"
            |push:("api-key: %s"|sprintf:"brevo_api_key")
            |push:"content-type: application/json"
        } as $api_response
      
        // Response variable
        var $response {
          value = $api_response.response.result
        }
      }
    
      catch {
        // Error Handling
        var $response {
          value = {}
            |set:"code":"ERROR"
            |set:"message":$error.message
        }
      }
    }
  }

  response = $response
}