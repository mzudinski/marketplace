workspace stripe_create_an_invoice {
  env = {stripe_api_key: ""}
}
---
function "$main" {
  input {
    object args {
      schema {
        text customer_id filters=trim
        text discount? filters=trim
        text description? filters=trim
        enum collection_method? {
          values = ["charge_automatically", "send_invoice"]
        }
      }
    }
  }

  stack {
    // Prepare body params
    group {
      stack {
        var $body_params {
          value = {}
            |set:"customer":$input.customer_id
        }
      
        var.update $body_params {
          value = `($input.discount|is_empty) == false ? ($var.body_params|set:"[\"discounts[0][coupon]\"]":$input.discount) : $var.body_params`
        }
      
        var.update $body_params {
          value = `($input.collection_method|is_empty) == false ? ($var.body_params|set:"collection_method":$input.collection_method) : $var.body_params`
        }
      
        var.update $body_params {
          value = `($input.description|is_empty) == false ? ($var.body_params|set:"description":$input.description) : $var.body_params`
        }
      }
    }
  
    // Stripe API Request
    group {
      stack {
        api.request {
          url = "https://api.stripe.com/v1/invoices"
          method = "POST"
          params = $body_params
          headers = []
            |push:("Authorization: Basic %s"
              |sprintf:($env.stripe_api_key|base64_encode)
            )
        } as $stripe_api
      }
    }
  
    precondition ($stripe_api.response.status == 200) {
      error = "The Stripe API returned with an error code: " ~ $var.stripe_api.response.result.error.code ~ " and message: " ~ $var.stripe_api.response.result.error.message
    }
  }

  response = $stripe_api.response.result
}