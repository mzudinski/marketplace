workspace resend_list_audiences {
  env = {resend_api_key: ""}
}
---
function "$main" {
  input {
  }

  stack {
    // Resend API call
    group {
      stack {
        api.request {
          url = "https://api.resend.com/audiences"
          method = "GET"
          headers = []
            |push:("Authorization: Bearer %s"|sprintf:$env.resend_api_key)
            |push:"Content-Type: application/json"
        } as $resend_api
      }
    }
  
    precondition ($resend_api.response.status == 200) {
      error = "Resend API returned with an error: %s"
        |sprintf:$resend_api.response.result.message
    }
  }

  response = $resend_api.response.result.data
}