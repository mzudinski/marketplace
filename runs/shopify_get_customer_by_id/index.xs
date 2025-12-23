function "Shopify -> Get Customer by ID" {
  input {
    text customer_id filters=trim
  }

  stack {
    // Shopify API 
    group {
      stack {
        api.request {
          url = "https://%s/admin/api/2025-01/graphql.json"|sprintf:$reg.store
          method = "POST"
          params = {}
            |set:"query":"query getCustomer($id: ID!) { customer(id: $id) { id email firstName lastName phone tags state amountSpent { amount currencyCode } createdAt updatedAt } }"
            |set:"variables":({}
              |set:"id":("gid://shopify/Customer/%s"|sprintf:$input.customer_id)
            )
          headers = []
            |push:"Content-Type: application/json"
            |push:("X-Shopify-Access-Token: %s"|sprintf:$reg.access_token)
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