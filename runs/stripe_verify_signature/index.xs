run.job "Stripe: Verify Signature" {
  main = {
    name : "Stripe: Verify Signature"
    input: {http_headers: "env.$http_headers"}
  }

  env = ["stripe_webhook_secret"]
}
---
function "Stripe: Verify Signature" {
  input {
    json http_headers
  }

  stack {
    // Setting up vars
    group {
      stack {
        util.get_raw_input {
          encoding = "json"
          exclude_middleware = false
        } as $raw_input
      
        var $stripe_signature {
          value = $input.http_headers
            |get:"Stripe-Signature":null
            |split:","
        }
      
        var $stripe_body {
          value = $raw_input|unset:"http_headers"
        }
      
        var $t {
          value = $stripe_signature
            |get:0:null
            |split:"="
            |get:1:null
        }
      
        var $v1 {
          value = $stripe_signature
            |get:1:null
            |split:"="
            |get:1:null
        }
      }
    }
  
    precondition ($t != null && $v1 != null) {
      error = "Uh oh, seems like the Stripe Signature header isn't valid! Please check the input variables."
    }
  
    // Creating the payload
    group {
      stack {
        var $signed_payload {
          value = $t
            |concat:($stripe_body|json_encode):"."
        }
      }
    }
  
    var $hmac_sha256_signature {
      value = $signed_payload
        |hmac_sha256:$env.stripe_webhook_secret:false
    }
  
    // Result
    group {
      stack {
        var $result {
          value = $var.hmac_sha256_signature == $var.v1
        }
      }
    }
  }

  response = {
    result              : $result
    stripe_signature    : $stripe_signature
    calculated_signature: $hmac_sha256_signature
  }
}