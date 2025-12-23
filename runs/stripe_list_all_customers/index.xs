function "Stripe -> List All Customers" {
  input {
    email email? filters=trim|lower
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
          value = `($input.email|is_empty) == false ? ($var.body_params|set:"email":$input.email) : $var.body_params`
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
          url = "https://api.stripe.com/v1/customers"
          method = "GET"
          params = $body_params
          headers = []
            |push:("Authorization: Bearer "|concat:"stripe_api_key":"")
        } as $stripe_api
      }
    }
  
    precondition ($stripe_api.response.status == 200) {
      error = "The Stripe API returned with an error code: " ~ $var.stripe_api.response.result.error.code ~ " and message: " ~ $var.stripe_api.response.result.error.message
    }
  }

  response = $stripe_api.response.result
}