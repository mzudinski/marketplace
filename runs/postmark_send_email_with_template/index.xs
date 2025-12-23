// # Function Documentation: Postmark → Send Email with Template
// ## Overview
// This function allows you to send emails using the Postmark API with a pre-defined template. You can specify the recipient email address, the template ID, and the data to populate the template placeholders.
// ## Inputs
// 1. **postmark_base_url** (registry|text) *Required*
//    - **Description:** The base url for calling the Postmark API  (e.g., "https://api.postmarkapp.com/").
// 2. **postmark_server_token** (registry|text) *Required* *Sensitive data*
//    - **Description:** This is the Postmark Server API Token (e.g., "14g8dce4-7054-47c9-a18a-2107e5cf4e41"). This is needed for authentication on endpoints.
// 3. **from_email** (text) *Required*
//    - **Description:** The email address that will appear as the sender.
//    - **Example:** `noreply@yourdomain.com`
// 4. **to_emails** (text) *Required*
//    - **Description:** A list of email addresses to send the batch emails to.
//    - **Example:** `user1@example.com`
// 3. **template_id** (integer) *Required*
//    - **Description:** The ID of the Postmark template to use.
//    - **Example:** 12345
// 4. **template_model** (json) *Required*
//    - **Description:** The data to populate the template placeholders. The structure of this data depends on your specific Postmark template.
//    - **Example:** Refer to Postmark documentation for template data structure.
// ## Function Stack
// ### 1. Create Variable:
//    - **Create Variable: `api_url`**
//    - **Purpose:** Constructs the API URL for sending emails with templates.
// ### 2. Create Variable:
//    - **Create Variable: `api_token`**
//    - **Purpose:** Stores the Postmark API token.
// ### 3. Precondition:
// 1. **Precondition: `from_email` should not exceed 255 characters.**
//    - **Purpose:** Ensures the sender email address is not too long.
// 2. **Precondition: `from_email` is a valid email format.**
//    - **Purpose:** Ensures the sender email address is formatted correctly.
// 3. **Precondition: `to_email` is a valid email format and allows comma-separated values.**
//    - **Purpose:** Ensures recipient email addresses are formatted correctly and the list is not too long.
// 4. **Precondition: `to_email` should not exceed 50 email addresses.**
//    - **Purpose:** Limits the number of recipients per batch.
// ### 4. Postmask API Request:
//    - **API Request to: `https://api.postmarkapp.com/email`**
//    - **Purpose:** Sends a POST request to the `api_url` with the following payload:
// ```JSON
// {
//   "from_email": "noreply@yourdomain.com",
//   "to_email": "user@example.com",
//   "template_id": 12345,
//   "template_model": {
//     "name": "John Doe",
//     "email": "john.doe@example.com"
//   }
// }
// ```
// ### 5. Create Variable:
//    - **Create Variable: `postmark_response`**
//    - **Purpose:** Stores the `response` from the Postmark API.
// ### 6. Create Variable:
//    - **Create Variable: `response`**
//    - **Purpose:** Creates a response object with the result from the Postmark API.
// ## Response
// - The function returns the result from the Postmark API response.
// ### Success response
// ```json
// {
//   "To": "user1@example.com",
//   "SubmittedAt": "2024-10-07T14:33:15.817Z",
//   "MessageID": "message-id-1",
//   "ErrorCode": 0,
//   "Message": "OK"
// },
// {
//   "To": "user2@example.com",
//   "SubmittedAt": "2024-10-07T14:33:15.817Z",
//   "MessageID": "message-id-2",
//   "ErrorCode": 0,
//   "Message": "OK"
// }
// ```
// ### Error response
// ```json
// {
//     "ErrorCode": 401,
//     "Message": "Unauthorized: Missing or incorrect API key."
// }
// ```
// ## Example
// ### Input
// ```json
// {
//   "from_email": "noreply@yourdomain.com",
//   "to_email": "user@example.com",
//   "template_id": 12345,
//   "template_model": {
//     "name": "John Doe",
//     "email": "john.doe@example.com"
//   }
// }
// ```
// ### Output
// ```json
// {
//   "To": "user@example.com",
//   "SubmittedAt": "2024-10-07T14:33:15.817Z",
//   "MessageID": "message-id-1",
//   "ErrorCode": 0,
//   "Message": "OK"
// }
// ```
function "Postmark Send email with template" {
  input {
    text from_email filters=trim|lower
    text to_email filters=trim|lower
    int template_id
    json template_model
  }

  stack {
    var $api_url {
      value = "postmark_base_url"|concat:"email/withTemplate":""
    }
  
    var $api_token {
      value = "postmark_api_token"
    }
  
    // Validation Logic
    group {
      stack {
        // Validate that from_email should not exceed 255 characters
        precondition (($input.from_email|strlen) <= 255) {
          error_type = "badrequest"
          error = "The from_email cannot exceed 255 characters. Please provide a shorter email address."
        }
      
        // Validate that from_email is a valid email format
        precondition ("/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$/"|regex_matches:$input.from_email) {
          error_type = "badrequest"
          error = "The from_email is not in a valid email format. Please provide a valid email address."
        }
      
        // Validate that to_email is a valid email format and allow comma separated values
        precondition ("/^([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}\\s*,?\\s*)+$/"|regex_matches:$input.to_email) {
          error_type = "badrequest"
          error = "The to_email is not in a valid email format. Please provide a valid email address. If you have multiple email address then please add them comma seperated."
        }
      
        // Validate that to_email should not exceed 50 email addresses
        precondition (($input.to_email|split:","|count) <= 50) {
          error_type = "badrequest"
          error = "The to_email cannot exceed 50 email addresses. "
        }
      }
    }
  
    api.request {
      url = $api_url
      method = "POST"
      params = {}
        |set:"From":$input.from_email
        |set:"To":$input.to_email
        |set:"TemplateId":$input.template_id
        |set:"TemplateModel":$input.template_model
      headers = []
        |push:"Accept: application/json"
        |push:"Content-Type: application/json"
        |push:("X-Postmark-Server-Token: "|concat:$api_token:"")
    } as $send_email_with_template_api
  
    var $postmark_response {
      value = $send_email_with_template_api.response.result
    }
  
    var $response {
      value = {}
        |set:"status":$send_email_with_template_api.response.status
        |set:"data":$postmark_response
    }
  }

  response = $response
  tags = ["postmark"]
}