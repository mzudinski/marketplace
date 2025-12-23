workspace resend_send_batch_email {
  env = {resend_api_key: ""}
}
---
// # Resend → Send Batch Email Xano Action
// 
// This Xano Action sends multiple emails at once using the Resend API's batch endpoint. It allows you to submit a list of emails (with associated payloads) and triggers all sends in a single API call. The API key is securely stored in the Settings Registry.
// 
// ---
// 
// ## Inputs
// 
// | Name   | Type   | Description                              |
// |--------|--------|------------------------------------------|
// | emails | object | Array of email objects to send in batch. |
// 
// Each email object should contain:
// - **from**: string — Sender's email address
// - **to**: array — Recipient(s) email address(es)
// - **subject**: string — The email subject
// - **text**: string — Email body in plain text
// - **html**: string — Email body in HTML format
// 
// ---
// 
// ## Settings Registry
// 
// | Name           | Type | Description                          |
// |----------------|------|--------------------------------------|
// | resend_api_key | text | API Key for authenticating Resend API |
// 
// ---
// 
// ## Function Stack
// 
// 1. **Resend API call**
//    - Sends a POST request to `https://api.resend.com/emails/batch`
//    - Body contains `emails` array as defined above
//    - Uses the API key from Settings Registry for authentication
//    - Checks that the API response status is 200 before proceeding
// 
// ---
// 
// ## Response
// 
// Returns the result from the Resend API batch call response as the output of the action.
// 
// ---
// 
// ## Example Usage
// 
// ```json
// {
//   "emails": [
//     {
//       "from": "onboarding@resend.dev",
//       "to": [
//         "michael@xano.com"
//       ],
//       "subject": "Batch Test 1",
//       "text": "Message 1",
//       "html": "<b>Message 1</b>"
//     },
//     {
//       "from": "onboarding@resend.dev",
//       "to": [
//         "alex@xano.com"
//       ],
//       "subject": "Batch Test 2",
//       "text": "Message 2",
//       "html": "<b>Message 2</b>"
//     }
//   ]
// }
// 
// ```
// 
// ---
// 
// This example will send two separate emails in one batch operation: one to `michael@xano.com` and another to `alex@xano.com`, each with different subjects and message bodies.
function "$main" {
  input {
    object args {
      schema {
        object[1:] emails {
          schema {
            email from filters=trim|lower
            email[1:] to filters=trim|lower
            text subject filters=trim
            text text? filters=trim
            text html? filters=trim
          }
        }
      }
    }
  }

  stack {
    // Resend API call
    group {
      stack {
        api.request {
          url = "https://api.resend.com/emails/batch"
          method = "POST"
          params = $input.emails
          headers = []
            |push:("Authorization: Bearer %s"|sprintf:$env.resend_api_key)
            |push:"Content-Type: application/json"
        } as $resend_api
      }
    }
  
    precondition ($resend_api.response.status == 200) {
      error = "Resend API returned with an error: %s"
        |sprintf:($resend_api.response.result
          |get:"error":$resend_api.response.status
        )
    }
  }

  response = $resend_api.response.result
}