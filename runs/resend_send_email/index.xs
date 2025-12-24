run "Resend -> Send Email" {
  type = "job"
  main = {name: "Resend -> Send Email", input: {}}
  env = ["resend_api_key"]
}
---
// # Resend → Send Email Xano Action
// 
// This Xano Action sends an email using the Resend API. It provides a simple interface for specifying the sender, recipients, subject, and content (text and HTML). The action securely uses an API key stored in the Settings Registry.
// 
// ---
// 
// ## Inputs
// 
// | Name    | Type             | Description                        |
// |---------|------------------|----------------------------------|
// | from    | email (string)   | Sender's email address            |
// | to      | email[] (array)  | Recipient(s) email address(es)    |
// | subject | text (string)    | Email subject                    |
// | text    | text (string)    | Plain text body of the email     |
// | html    | text (string)    | HTML body of the email            |
// 
// ---
// 
// ## Settings Registry
// 
// | Name           | Type   | Description                  |
// |----------------|--------|------------------------------|
// | resend_api_key | text   | API Key for Resend API access |
// 
// ---
// 
// ## Function Stack
// 
// 1. **Resend API call**
// 
//    - Sends a POST request to `https://api.resend.com/emails`
//    - Uses inputs `from`, `to`, `subject`, `text`, and `html` as request body
//    - Uses `resend_api_key` from Settings Registry for authentication
//    - Checks API response status is 200 before proceeding
// 
// ---
// 
// ## Response
// 
// Returns the result from the Resend API response as the output of the action.
// 
// ---
// 
// ## Example Usage
// 
// ```
// 
// {
// "from": "onboarding@resend.dev",
// "to": ["michael@xano.com"],
// "subject": "Test",
// "text": "Test123",
// "html": "Test"
// }
// 
// ```
// 
// ---
// 
// This example sends a test email from `onboarding@resend.dev` to `michael@xano.com` with the subject "Test" and both text and HTML body content "Test123" and "Test" respectively.
function "Resend -> Send Email" {
  input {
    email from filters=trim|lower
    email[1:] to filters=trim|lower
    text subject filters=trim
    text text? filters=trim
    text html? filters=trim
  }

  stack {
    // Resend API call
    group {
      stack {
        api.request {
          url = "https://api.resend.com/emails"
          method = "POST"
          params = {}
            |set:"from":$input.from
            |set:"to":$input.to
            |set:"subject":$input.subject
            |set:"html":$input.html
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