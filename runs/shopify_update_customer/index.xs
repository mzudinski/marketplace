// Xano Action: Update Shopify Customer
// This Xano action updates an existing customer in a Shopify store using their unique Customer GID.
// 
// Inputs
// Name	Type	Description
// shopify_admin_api_key	registry	text
// store_name	text	The unique name of your Shopify store.
// customer_id	text	The unique Shopify GID of the customer to update.
// firstName	text	(Optional) The customer's new first name.
// lastName	text	(Optional) The customer's new last name.
// 
// Export to Sheets
// Function Stack
// Shopify API Request
// 
// API Endpoint: https://%s.myshopify.com/admin/api/2025-01/graphql.json
// 
// HTTP Method: POST
// 
// Headers:
// 
// X-Shopify-Access-Token: <shopify_admin_api_key>
// 
// Content-Type: application/json
// 
// Body:
// 
// JSON
// 
// {
//   "query": "mutation customerUpdate($input: CustomerInput!) { customerUpdate(input: $input) { customer { id firstName lastName } userErrors { field message } } }",
//   "variables": {
//     "input": {
//       "id": "<customer_id>",
//       "firstName": "<firstName>"
//     }
//   }
// }
// Replace %s in the endpoint with the provided store_name.
// 
// The input object in the variables should be constructed dynamically with the provided customer_id and any other optional fields.
// 
// Precondition
// 
// Ensures that the HTTP request was successful.
// 
// Condition: shopify_api_response.status == 200
// 
// If this condition fails, execution halts and an error is thrown.
// 
// Response
// The action returns the result of the Shopify API response.
// 
// Key	Value
// As Self	Returns shopify_api_response.result
// 
// Export to Sheets
// Example
// Input
// JSON
// 
// {
//     "store_name": "my-cool-shop",
//     "customer_id": "gid://shopify/Customer/9876543210987",
//     "firstName": "Janet"
// }
// Output
// JSON
// 
// {
//   "data": {
//     "customerUpdate": {
//       "customer": {
//         "id": "gid://shopify/Customer/9876543210987",
//         "firstName": "Janet",
//         "lastName": "Doe"
//       },
//       "userErrors": []
//     }
//   }
// }
function "Shopify -> Update Customer" {
  input {
    text customer_id filters=trim
    text firstName? filters=trim
    text lastName? filters=trim
    email email? filters=trim|lower
  }

  stack {
    // Shopify API 
    group {
      stack {
        api.request {
          url = "https://%s/admin/api/2025-01/graphql.json"|sprintf:$reg.store
          method = "POST"
          params = {}
            |set:"query":"mutation customerUpdate($input: CustomerInput!) { customerUpdate(input: $input) { customer { id firstName } userErrors { field message } } }"
            |set:"variables":({}
              |set:"input":({}
                |set:"id":("gid://shopify/Customer/%s"|sprintf:$input.customer_id)
                |set:"firstName":$input.firstName
                |set:"lastName":$input.lastName
                |set:"email":$input.email
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