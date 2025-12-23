workspace shopify_get_all_orders {
  env = {access_token: "", store: ""}
}
---
function "$main" {
  input {
  }

  stack {
    // Shopify API 
    group {
      stack {
        api.request {
          url = "https://%s/admin/api/2025-07/graphql.json"|sprintf:$env.store
          method = "POST"
          params = {}
            |set:"query":"query { orders(first: 10) { edges { cursor node { id } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } } }"
          headers = []
            |push:"Content-Type: application/json"
            |push:("X-Shopify-Access-Token: %s"|sprintf:$env.access_token)
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