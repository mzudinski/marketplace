// ## Function Documentation: QuickBooks -> Create Payment
// [Quickbooks API documentation](https://developer.intuit.com/app/developer/qbdesktop/docs/api-reference/qbdesktop)
// 
// 
// ## Overview
// This function creates a payment in QuickBooks by making an API call. It uses the QuickBooks API with the provided realm ID, amount, and consumer reference.
// 
// - This action works on production environment only, for sandbox environment refer documentation at `https://developer.intuit.com/app/developer/qbo/docs/api/accounting/all-entities/payment#create-a-payment`.
// ## Inputs
// 
// 1. **quickbooks_realm_id** (registry/text) *Required*
//    - **Description:** The QuickBooks realm ID associated with the account.
//    - **Example:** `quickbooks_realm_abc123`
// 
// 2. **amount** (decimal) *Required*
//    - **Description:** The amount of the payment to be created.
//    - **Example:** `100.50`
// 
// 3. **consumer_ref** (integer) *Required*
//    - **Description:** A reference number associated with the consumer.
//    - **Example:** `12345`
// 
// 4. **quickbooks_api_token** (registry|text) *Required*
//    - **Description:** The JWT token used to authenticate requests to the quickbooks API.
//    - **Example:** `xkeysib-...`
// 
// ## Function Stack
// 
// ### 1. Try / Catch Block
// 
// #### 1. QuickBooks API Call
// 
//  **API Request to `https://quickbooks.api.intuit.com/v3/company/{quickbooks_realm_id}/payment`**
//    - **Purpose:** Sends a payment creation request to QuickBooks using the realm ID, amount, and consumer reference.
//    - **Return Value:** The API response is stored as `response`.
// 
// #### 2. Response Variable
//    - **Variable:** `var: response = var: quickbooks_api_response.response`
//    - **Purpose:** Captures the response returned by the QuickBooks API.
// 
// ### 2. Error Handling (Catch)
// 
// 1. **Create Variable: `response`**
//     - **Purpose:** Catches and handles any errors that occur during the QuickBooks API call and logs the error message.
// 
// ## Response
// 
// The function returns the result of the QuickBooks payment creation.
// 
// ### Success Response
// ```json
// {
//  "Payment": {
//   "CustomerRef": {
//    "value": "20",
//    "name": "Red Rock Diner"
//   },
//   "DepositToAccountRef": {
//    "value": "4"
//   },
//   "TotalAmt": 25,
//   "UnappliedAmt": 25,
//   "ProcessPayment": false,
//   "domain": "QBO",
//   "sparse": false,
//   "Id": "150",
//   "SyncToken": "0",
//   "MetaData": {
//    "CreateTime": "2024-10-11T07:17:33-07:00",
//    "LastUpdatedTime": "2024-10-11T07:17:33-07:00"
//   },
//   "TxnDate": "2024-10-11",
//   "CurrencyRef": {
//    "value": "USD",
//    "name": "United States Dollar"
//   }
//  },
//  "time": "2024-10-11T07:17:32.610-07:00"
// }
// ```
// ### Error Response
// 
// ```json
// {
//     "type": "error",
//     "error": {
//         "code": "payment_creation_failed",
//         "message": "Failed to create the payment due to an invalid realm ID."
//     }
// }
// ```
// 
// ## Example
// 
// ### Input
// ```json
// {
//     "quickbooks_realm_id": "{quickbooks_realm_id}",
//     "amount": "{amount}",
//     "consumer_ref": "{consumer_ref}"
// }
// ```
// 
// ### Output
// ```json
// {
//  "Payment": {
//   "CustomerRef": {
//    "value": "20",
//    "name": "Red Rock Diner"
//   },
//   "DepositToAccountRef": {
//    "value": "4"
//   },
//   "TotalAmt": 25,
//   "UnappliedAmt": 25,
//   "ProcessPayment": false,
//   "domain": "QBO",
//   "sparse": false,
//   "Id": "150",
//   "SyncToken": "0",
//   "MetaData": {
//    "CreateTime": "2024-10-11T07:17:33-07:00",
//    "LastUpdatedTime": "2024-10-11T07:17:33-07:00"
//   },
//   "TxnDate": "2024-10-11",
//   "CurrencyRef": {
//    "value": "USD",
//    "name": "United States Dollar"
//   }
//  },
//  "time": "2024-10-11T07:17:32.610-07:00"
// }
// 
// ```
function "QuickBooks -> Create Payment" {
  input {
    decimal amount
    int consumer_ref
  }

  stack {
    try_catch {
      try {
        // QuickBooks API Call
        api.request {
          url = "https://quickbooks.api.intuit.com/v3/company/%s/payment?minorversion=73"|sprintf:"quickbooks_realm_id"
          method = "POST"
          params = {}
            |set:"TotalAmt":$input.amount
            |set:"CustomerRef":({}
              |set:"value":($input.consumer_ref|to_text)
            )
          headers = []
            |push:"Content-Type: application/json"
            |push:("Authorization: Bearer %s"|sprintf:"quickbooks_api_token")
        } as $api1
      
        // Response Variable
        var $response {
          value = $api1.response.result
        }
      }
    
      catch {
        // Error Handling
        var $response {
          value = {}
            |set:"code":"ERROR"
            |set:"message":$error.message
        }
      }
    }
  }

  response = $response
}