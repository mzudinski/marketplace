workspace postmark_send_single_email {
  env = {postmark_base_url: "", postmark_api_token: ""}
}
---
function "$main" {
  input {
    object args {
      schema {
        text from_email filters=trim|lower
        text to_email filters=trim|lower
        text subject? filters=trim
        text text_body? filters=trim
        text html_body? filters=trim
      }
    }
  }

  stack {
    var $api_url {
      value = "postmark_base_url"|concat:"email":""
    }
  
    var $api_token {
      value = "postmark_api_token"
    }
  
    // Validation Logic
    group {
      stack {
        // Validate that from_email should not exceed 255 characters
        precondition (($input.from_email|strlen) <= 255) {
          error_type = "notfound"
          error = "The from_email cannot exceed 255 characters. Please provide a shorter email address."
        }
      
        // Validate that from_email is a valid email format
        precondition ("/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$/"|regex_matches:$input.from_email) {
          error_type = "notfound"
          error = "The from_email is not in a valid email format. Please provide a valid email address."
        }
      
        // Validate that to_email is a valid email format and allow comma separated values
        precondition ("/^([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}\\s*,?\\s*)+$/"|regex_matches:$input.to_email) {
          error_type = "notfound"
          error = "The to_email is not in a valid email format. Please provide a valid email address. If you have multiple email address then please add them comma seperated."
        }
      
        // Validate that to_email should not exceed 50 email addresses
        precondition (($input.to_email|split:","|count) <= 50) {
          error_type = "notfound"
          error = "The to_email cannot exceed 50 email addresses. "
        }
      
        // Validate that either text_body or html_body (or both) are provided
        // 
        precondition (($input.text_body|is_empty) == false || ($input.html_body|is_empty) == false) {
          error_type = "notfound"
          error = "You must provide either text_body or html_body, or both. Both fields cannot be"
        }
      
        // Validate that html_body is a valid html format
        precondition (($input.html_body|is_empty) || ("/^<([a-z]+)([^<]+)*(?:>(.*)<\\/\\1>|\\s+\\/>)$/"|regex_matches:$input.html_body)) {
          error_type = "notfound"
          error = "The html_body must be in a valid HTML format."
        }
      }
    }
  
    api.request {
      url = $api_url
      method = "POST"
      params = {}
        |set:"From":$input.from_email
        |set:"To":$input.to_email
        |set:"Subject":$input.subject
        |set:"TextBody":$input.text_body
        |set:"HtmlBody":$input.html_body
        |set:"MessageStream":"outbound"
      headers = []
        |push:"Accept: application/json"
        |push:"Content-Type: application/json"
        |push:("X-Postmark-Server-Token: "|concat:$api_token:"")
    } as $send_single_email_api
  
    var $postmark_response {
      value = $send_single_email_api.response.result
    }
  
    var $response {
      value = {}
        |set:"status":$send_single_email_api.response.status
        |set:"data":$postmark_response
    }
  
    conditional {
      if ($response.status == 200 && $response.data.ErrorCode == 0) {
        var.update $response {
          value = $response
            |set:"code":"SUCCESS"
            |set:"message":"Email sent successfull"
        }
      }
    
      else {
        var.update $response {
          value = $response
            |set:"code":"ERROR"
            |set:"message":$response.data.Message
        }
      }
    }
  }

  response = $response
  tags = ["postmark"]
}