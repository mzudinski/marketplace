workspace stripe_void_invoice {
  env = {stripe_api_key: ""}
}
---
function "$main" {
  input {
    text invoice_id filters=trim
  }

  stack {
    // Stripe API Request
    group {
      stack {
        api.request {
          url = "https://api.stripe.com/v1/invoices/%s/void"|sprintf:$input.invoice_id
          method = "POST"
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