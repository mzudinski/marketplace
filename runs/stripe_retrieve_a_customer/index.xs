workspace stripe_retrieve_a_customer {
  env = {stripe_api_key: ""}
}
---
function "Stripe -> Retrieve a Customer" {
  input {
    text customer_id filters=trim
  }

  stack {
    // Stripe API call
    group {
      stack {
        api.request {
          url = "https://api.stripe.com/v1/customers/%s"|sprintf:$input.customer_id
          method = "GET"
          headers = []
            |push:("Authorization: Bearer "|concat:$env.stripe_api_key:"")
        } as $stripe_api
      }
    }
  
    precondition ($stripe_api.response.status == 200) {
      error = "The Stripe API returned with an error code: " ~ $var.stripe_api.response.result.error.code ~ " and message: " ~ $var.stripe_api.response.result.error.message
    }
  }

  response = $stripe_api.response.result
}