workspace shopify_create_customer {
  env = {access_token: "", store: ""}
}
---
function "Shopify -> Create Customer" {
  input {
    email email filters=trim|lower
    text firstName filters=trim
    text lastName filters=trim
  }

  stack {
    // Shopify API 
    group {
      stack {
        api.request {
          url = "https://%s/admin/api/2025-01/graphql.json"|sprintf:$env.store
          method = "POST"
          params = {}
            |set:"query":"mutation customerCreate($input: CustomerInput!) { customerCreate(input: $input) { customer { id email } userErrors { field message } } }"
            |set:"variables":({}
              |set:"input":({}
                |set:"email":$input.email
                |set:"firstName":$input.firstName
                |set:"lastName":$input.lastName
              )
            )
          headers = []
            |push:"Content-Type: application/json"
            |push:("X-Shopify-Access-Token: %s"|!sprintf:$env.access_token)
        } as $shopify_api
      }
    }
  
    precondition ($shopify_api.response.status == 200) {
      error = "Uh oh, the Shopify API responded with a %s"
        |sprintf:$shopify_api.response.status
    }
  }

  response = $shopify_api.response.result
}