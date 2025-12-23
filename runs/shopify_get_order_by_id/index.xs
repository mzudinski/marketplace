workspace shopify_get_order_by_id {
  env = {access_token: "", store: ""}
}
---
function "Shopify -> Get Order by ID" {
  input {
    int id
  }

  stack {
    // Shopify API 
    group {
      stack {
        api.request {
          url = "https://%s/admin/api/2025-07/graphql.json"|sprintf:$env.store
          method = "POST"
          params = {}
            |set:"query":"query GetOrderById($id: ID!) { order(id: $id) { id name displayFinancialStatus totalPriceSet { shopMoney { amount currencyCode } } } }"
            |set:"variables":({}
              |set:"id":("gid://shopify/Order/%s"|sprintf:$input.id)
            )
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