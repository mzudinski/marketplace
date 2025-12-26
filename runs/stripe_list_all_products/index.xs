run.job "Stripe -> List All Products" {
  main = {
    name : "Stripe -> List All Products"
    input: {starting_after: "prod_1234", limit: 5}
  }

  env = ["stripe_api_key"]
}
---
function "Stripe -> List All Products" {
  input {
    text starting_after? filters=trim
    int limit?
  }

  stack {
    // Prepare body params
    group {
      stack {
        var $body_params {
          value = {}
        }
      
        var.update $body_params {
          value = `($input.starting_after|is_empty) == false ? ($var.body_params|set:"starting_after":$input.starting_after) : $var.body_params`
        }
      
        var.update $body_params {
          value = `($input.limit|is_empty) == false ? ($var.body_params|set:"limit":$input.limit) : $var.body_params`
        }
      }
    }
  
    // Stripe API call
    group {
      stack {
        api.request {
          url = "https://api.stripe.com/v1/products"
          method = "GET"
          params = $body_params
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