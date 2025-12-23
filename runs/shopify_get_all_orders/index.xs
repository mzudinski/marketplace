function "Shopify -> Get All Orders" {
  input {
  }

  stack {
    // Shopify API 
    group {
      stack {
        api.request {
          url = "https://%s/admin/api/2025-07/graphql.json"|sprintf:"store"
          method = "POST"
          params = {}
            |set:"query":"query { orders(first: 10) { edges { cursor node { id } } pageInfo { hasNextPage hasPreviousPage startCursor endCursor } } }"
          headers = []
            |push:"Content-Type: application/json"
            |push:("X-Shopify-Access-Token: %s"|sprintf:"access_token")
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