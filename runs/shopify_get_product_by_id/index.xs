workspace shopify_get_product_by_id {
  env = {access_token: "", store: ""}
}
---
// # Shopify - Get Product By ID 
// 
// This Xano Action retrieves a single product from Shopify using the Shopify Admin GraphQL API and a given `product_id`. It uses secure credentials stored in the Settings Registry.
// 
// ---
// 
// ## Inputs
// 
// | Name         | Type           | Description                                                          |
// |--------------|----------------|----------------------------------------------------------------------|
// | access_token | registry/text  | Shopify Admin API Access Token                                      |
// | store        | registry/text  | Shopify store domain (e.g., `myshop.myshopify.com`)                 |
// | product_id   | text           | The Shopify product ID (recommended: GraphQL global ID format)      |
// 
// ---
// 
// ## Function Stack
// 
// 1. **Shopify API Request**  
//    - **Method:** `POST`  
//    - **Endpoint:**  
//      ```text
//      https://%s/admin/api/2025-07/graphql.json
//      ```
//      (`%s` is replaced via `sprintf` using the `store` registry value)
//    - **Authentication:** `access_token` from the Settings Registry  
//    - **Suggested GraphQL Query Payload (example):**  
//      ```graphql
//      query getProductById($id: ID!) {
//        product(id: $id) {
//          id
//          title
//          handle
//          status
//          description
//          createdAt
//          updatedAt
//          totalInventory
//        }
//      }
//      ```
//    - **Suggested Variables (example):**
//      ```json
//      {
//        "id": "product_id"
//      }
//      ```
//    - **Returns:** `shopify_api`
// 
// 2. **Precondition**  
//    - Ensures the Shopify API request succeeded before continuing.  
//    - Condition:
//      ```text
//      var: shopify_api.response.status == 200
//      ```
// 
// ---
// 
// ## Response
// 
// Configure the action response to return the raw GraphQL result from Shopify:
// 
// | Key     | Value                              |
// |---------|------------------------------------|
// | As Self | `var: shopify_api.response.result` |
// 
// This will include the `data.product` object (or any GraphQL errors) from Shopify.
// 
// ---
// 
// ## Example Usage
// 
// **Request**
// ```json
// {
//   "product_id": "gid://shopify/Product/1234567890"
// }
// 
function "$main" {
  input {
    text product_id? filters=trim
  }

  stack {
    // Shopify API 
    group {
      stack {
        api.request {
          url = "https://%s/admin/api/2025-07/graphql.json"|sprintf:$env.store
          method = "POST"
          params = {}
            |set:"query":"query($identifier: ProductIdentifierInput!) { product: productByIdentifier(identifier: $identifier) { id title handle descriptionHtml status createdAt updatedAt vendor productType tags variants(first: 50) { edges { node { id title sku price inventoryQuantity createdAt updatedAt } } } images(first: 10) { edges { node { id src altText } } } } }"
            |set:"variables":({}
              |set:"identifier":({}
                |set:"id":("gid://shopify/Product/%s"|sprintf:$input.product_id)
              )
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