workspace hubspot_get_deal {
  env = {hubspot_api_key: ""}
}
---
// # HubSpot → Get Deal
// 
// ## Overview
// This function retrieves a specific deal from HubSpot using the deal's ID. It involves setting environment variables, preparing the request, and handling the response from the HubSpot API.
// 
// ## Inputs
// 1. **hubspot_api_key** (registry|text) *Required* *Sensitive data*
//    - **Description:** The API key for your HubSpot account.
// 
// 2. **deal_id** (integer)
//    - **Description:** The unique identifier of the deal to be retrieved.
// 
// 3. **properties** (text[])
//    - **Description:** A list of deal properties to retrieve.
// 
// 4. **properties_with_history** (text[])
//    - **Description:** A list of deal properties with their history to retrieve.
// 
// ## Function Stack
// ### 1. HubSpot API Request
// 1. **API Request to `https://api.hubapi.com/crm/v3/objects/deals/{deal_id}`**
//    - **Purpose:** Sends a GET request to retrieve the specified deal from HubSpot.
// 
// ### 2. Preconditions
// 1. **Precondition: `hubspot_api.response.status == 200`**
//    - **Purpose:** Ensures successful retrieval of the deal with HTTP status code 200.
// 
// ## Response
// - The function returns the result from the HubSpot API response.
// 
// ### Success response
// ```json
// {
//   "deal_id": 22413038713,
//   "properties": [],
//   "properties_with_history": [
//     "closed_won_reason"
//   ]
// }
// ```
// 
// 
// ### Error response
// ```json
// {
//     "message": "Uh oh! Hubspot returned with an error: Authentication credentials not found. This API supports OAuth 2.0 authentication and you can find more details at https://developers.hubspot.com/docs/methods/auth/oauth-overview"
// }
// ```
// 
// ## Example
// ### Input
// ```json
// {
//   "deal_id": 22413038713,
//   "properties": [],
//   "properties_with_history": [
//     "closed_won_reason"
//   ]
// }
// ```
// 
// ### Output
// ```json
// {
//     "id": "22413038713",
//     "properties": {
//         "amount": "1456.55",
//         .
//         .
//         .
//     },
//     "createdAt": "2024-09-26T12:02:50.213Z",
//     "updatedAt": "2024-09-26T12:02:50.213Z",
//     "archived": false
// }
// ```
function "$main" {
  input {
    object args {
      schema {
        int deal_id
        text[] properties? filters=trim
        text[] properties_with_history? filters=trim
      }
    }
  }

  stack {
    // Hubspot API Request
    group {
      stack {
        api.request {
          url = "https://api.hubapi.com/crm/v3/objects/deals/"|concat:$input.deal_id:""
          method = "GET"
          params = {}
            |set:"archived":"false"
            |set:"properties":($input.properties|join:",")
            |set:"propertiesWithHistory":($input.properties_with_history|join:",")
          headers = []
            |push:("authorization: Bearer %s"|sprintf:$env.hubspot_api_key)
        } as $hubspot_api
      }
    }
  
    precondition ($hubspot_api.response.status == 200) {
      error = "Uh oh! Hubspot returned with an error: %s"
        |sprintf:($hubspot_api.response.result
          |get:"message":$hubspot_api.response.status
        )
    }
  }

  response = $hubspot_api.response.result
}