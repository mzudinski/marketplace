// **Stripe - Create an Invoice Item**
// ## How to Get the Stripe API Key
// To retrieve your Stripe API key, follow these steps:
// 
// 1. Log in to your Stripe dashboard at [https://dashboard.stripe.com](https://dashboard.stripe.com).
// 2. Navigate to **Developers** > **API keys**.
// 3. Locate the **Secret Key** under the **Standard keys** section.
// 4. Click **Reveal test key** (for testing) or use the live key for production.
// 5. Copy the API key and store it securely.
// 
// **Note:** Never expose your API key in client-side applications.
// ### 1. Inputs
// Specify if this function accepts any inputs or query parameters:
// - **customer_id** (text)
// - **invoice_id** (text)
// - **price_id** (text)
// - **stripe_api_key** (registry text from Settings Registry)
// 
// ### 2. Function Stack
// 
// 1. **Stripe API Request**
//    - API Request to: `https://api.stripe.com/v1/invoiceitems`
//    - Returns as: `stripe_api`
// 2. **Precondition**
//    - Condition: `var: stripe_api.response.status = 200`
// 
// ### 3. Response
// - **Key:** As Self
// - **Value:** `var: stripe_api.response.result`
// 
// This function allows creating an invoice item in Stripe by making a request to the Stripe API with the necessary inputs. The API request ensures that a valid response (status 200) is received before proceeding.
// 
// 
// ## Example Response
// ```json
// {
//   "id": "ii_123456789",
//   "object": "invoiceitem",
//   "customer": "cus_ABC123",
//   "invoice": "in_987654321",
//   "price": "price_001",
//   "amount": 2000,
//   "currency": "usd",
//   "description": "Service Charge",
//   "created": 1700000000,
//   "livemode": false
// }
// ```
function "Stripe -> Create an Invoice Item" {
  input {
    text customer_id filters=trim
    text price_id? filters=trim
  }

  stack {
    // Stripe API Request
    group {
      stack {
        api.request {
          url = "https://api.stripe.com/v1/invoiceitems"
          method = "POST"
          params = {}
            |set:"customer":$input.customer_id
            |set:"price":$input.price_id
          headers = []
            |push:("Authorization: Basic %s"
              |sprintf:($reg.stripe_api_key|base64_encode)
            )
        } as $stripe_api
      }
    }
  
    precondition ($stripe_api.response.status == 200) {
      error = "The Stripe API returned with an error code: " ~ $var.stripe_api.response.result.error.code ~ " and message: " ~ $var.stripe_api.response.result.error.message
    }
  }

  response = $stripe_api.response.result
}