function "Shopify -> Create Order" {
  input {
    text currency_code? filters=trim
    json[] line_items?
  }

  stack {
    // Shopify API 
    group {
      stack {
        api.request {
          url = "https://%s/admin/api/2025-07/graphql.json"|sprintf:$reg.store
          method = "POST"
          params = {}
            |set:"query":"mutation orderCreate($order: OrderCreateOrderInput!, $options: OrderCreateOptionsInput) { orderCreate(order: $order, options: $options) { userErrors { field message } order { id totalTaxSet { shopMoney { amount currencyCode } } lineItems(first: 5) { nodes { variant { id } id title quantity taxLines { title rate priceSet { shopMoney { amount currencyCode } } } } } } } }"
            |set:"variables":({}
              |set:"order":({}
                |set:"currency":$input.currency_code
                |set:"lineItems":$input.line_items
              )
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