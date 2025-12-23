workspace postmark_send_batch_emails {
  env = {postmark_base_url: "", postmark_api_token: ""}
}
---
function "$main" {
  input {
    object args {
      schema {
        object[1:] messages? {
          schema {
            text from_email filters=trim
            text to_email filters=trim
            text subject? filters=trim
            text text_body? filters=trim
            text html_body? filters=trim
          }
        }
      }
    }
  }

  stack {
    var $api_url {
      value = "postmark_base_url"|concat:"email/batch":""
    }
  
    var $api_token {
      value = "postmark_api_token"
    }
  
    var $messages_payload {
      value = []
    }
  
    // Validation Logic & Convert messages to Postmark format
    group {
      stack {
        var $message_counter {
          value = 1
        }
      
        // Validate that from_email should not exceed 255 characters
        precondition (($input.messages|count) <= 500) {
          error = "The messages cannot exceed 500 messages. Please provide a shorter email address."
        }
      
        foreach ($input.messages) {
          each as $message {
            // Validate that from_email should not exceed 255 characters
            precondition (($message.from_email|strlen) <= 255) {
              error = "In message no."
                |concat:$message_counter:" "
                |concat:"the from_email cannot exceed 255 characters. Please provide a shorter email address.":" "
            }
          
            // Validate that from_email is a valid email format
            precondition ("/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$/"|regex_matches:$message.from_email) {
              error_type = "badrequest"
              error = "In message no."
                |concat:$message_counter:" "
                |concat:"the from_email is not in a valid email format. Please provide a valid email address.":" "
            }
          
            // Validate that to_email is a valid email format and allow comma separated values
            precondition ("/^([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}\\s*,?\\s*)+$/"|regex_matches:$message.to_email) {
              error_type = "badrequest"
              error = "In message no."
                |concat:$message_counter:" "
                |concat:"the to_email is not in a valid email format. Please provide a valid email address. If you have multiple email address then please add them comma seperated.":" "
            }
          
            // Validate that to_email should not exceed 50 email addresses
            precondition (($message.to_email|split:","|count) <= 50) {
              error_type = "badrequest"
              error = "In message no."
                |concat:$message_counter:" "
                |concat:"the to_email cannot exceed 50 email addresses. ":" "
            }
          
            // Validate that either text_body or html_body (or both) are provided
            // 
            precondition (($message.text_body|is_empty) == false || ($message.html_body|is_empty) == false) {
              error_type = "notfound"
              error = "In message no."
                |concat:$message_counter:" "
                |concat:"you must provide either text_body or html_body, or both. Both fields cannot be.":" "
            }
          
            // Validate that html_body is a valid html format
            precondition (($message.html_body|is_empty) == false && ("/^<([a-z]+)([^<]+)*(?:>(.*)<\\/\\1>|\\s+\\/>)$/"|regex_matches:$message.html_body)) {
              error = "In message no."
                |concat:$message_counter:" "
                |concat:"the html_body must be in a valid HTML format.":" "
            }
          
            // Convert message to Postmark format
            group {
              stack {
                var $postmark_message {
                  value = {}
                    |set:"From":$message.from_email
                    |set:"To":$message.to_email
                    |set:"Subject":$message.subject
                    |set:"TextBody":$message.text_body
                    |set:"HtmlBody":$message.html_body
                    |set:"MessageStream":"outbound"
                }
              
                var.update $messages_payload {
                  value = $messages_payload|push:$postmark_message
                }
              }
            }
          
            var.update $message_counter {
              value = $message_counter|add:1
            }
          }
        }
      }
    }
  
    api.request {
      url = $api_url
      method = "POST"
      params = $messages_payload
      headers = []
        |push:"Accept: application/json"
        |push:"Content-Type: application/json"
        |push:("X-Postmark-Server-Token: "|concat:$api_token:"")
    } as $send_batch_emails_api
  
    var $postmark_response {
      value = $send_batch_emails_api.response.result
    }
  
    var $response {
      value = {}
        |set:"status":$send_batch_emails_api.response.status
        |set:"data":$postmark_response
    }
  }

  response = $response
  tags = ["postmark"]
}