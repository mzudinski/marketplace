// # HubSpot → List Deals
// 
// ## Overview
// This function retrieves a list of deals from HubSpot. It involves setting environment variables, preparing the request with optional parameters, and handling the response from the HubSpot API.
// 
// ## Inputs
// 1. **hubspot_api_key** (registry|text) *Required* *Sensitive data*
//    - **Description:** The API key for your HubSpot account.
// 
// 2. **after** (integer)
//    - **Description:** The paging cursor to get the next set of deals.
// 
// 3. **limit** (integer)
//    - **Description:** The maximum number of deals to retrieve.
// 
// 4. **properties** (text[])
//    - **Description:** A list of deal properties to retrieve.
// 
// 5. **properties_with_history** (text[])
//    - **Description:** A list of deal properties with their history to retrieve.
// 
// ## Function Stack
// ### 1. HubSpot API Request
// 1. **API Request to `https://api.hubapi.com/crm/v3/objects/deals`**
//    - **Purpose:** Sends a GET request to retrieve deals from HubSpot.
//    - **Parameters:** Includes optional `after` cursor, `limit`, and specified `properties`.
// 
// ### 2. Preconditions
// 1. **Precondition: `hubspot_api.response.status == 200`**
//    - **Purpose:** Ensures successful retrieval of deals with HTTP status code 200.
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
//   "after": "22393633108",
//   "limit": 10,
//   "properties": [],
//   "properties_with_history": [
//     "dealname"
//   ]
// }
// ```
// 
// ### Output
// ```json
// [
//     {
//         "id": "22393633108",
//         .
//         .
//         .
//     },
//     .
//     .
// ]
// ```
function "Hubspot -> List Deals" {
  input {
    text after? filters=trim
    int limit?
    text[] properties? filters=trim
    text[] properties_with_history? filters=trim
  }

  stack {
    // Hubspot API Request
    group {
      stack {
        api.request {
          url = "https://api.hubapi.com/crm/v3/objects/deals"
          method = "GET"
          params = {}
            |set:"archived":"false"
            |set:"properties":($input.properties|join:",")
            |set:"propertiesWithHistory":($input.properties_with_history|join:",")
          headers = []
            |push:("authorization: Bearer %s"|sprintf:"hubspot_api_key")
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

  response = $hubspot_api.response.result.results
}