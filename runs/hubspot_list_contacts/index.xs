run.job "Hubspot -> List Contacts" {
  main = {name: "Hubspot -> List Contacts", input: {}}
  env = ["hubspot_api_key"]
}
---
// # Function Documentation: HubSpot → List Contacts
// 
// ## Overview
// This function retrieves a list of contacts from HubSpot. It involves setting environment variables, preparing the request with optional parameters, and handling the response from the HubSpot API.
// 
// ## Inputs
// 1. **hubspot_api_key** (registry|text) *Required* *Sensitive data*
//    - **Description:** The API key for your HubSpot account.
// 
// 2. **after** (integer)
//    - **Description:** The paging cursor to get the next set of contacts.
// 
// 3. **properties** (text[])
//    - **Description:** A list of contact properties to retrieve.
// 
// ## Function Stack
// ### 1. HubSpot API Request
// 1. **API Request to `https://api.hubapi.com/crm/v3/objects/contacts`**
//    - **Purpose:** Sends a GET request to retrieve contacts from HubSpot.
//    - **Parameters:** Includes `archived=false`, optional `after` cursor, and specified `properties`.
// 
// ### 2. Preconditions
// 1. **Precondition: `hubspot_api.response.status == 200`**
//    - **Purpose:** Ensures successful retrieval of contacts with HTTP status code 200.
// 
// ## Response
// - The function returns the result from the HubSpot API response.
// 
// ### Success response
// ```json
// {
//   "results": [
//     {
//       "id": "123456789",
//       "properties": {
//         "createdate": "2024-09-12T11:36:05.267Z",
//         "hs_marketable_status": "false",
//         "hs_object_id": "123456789",
//         "lastmodifieddate": "2024-09-12T11:36:22.982Z"
//       },
//       "createdAt": "2024-09-12T11:36:05.267Z",
//       "updatedAt": "2024-09-12T11:36:22.982Z",
//       "archived": false
//     },
//     .
//     .
//     .
//   ],
//   "paging": {
//     "next": {
//       "after": "123456789",
//       "link": "https://api.hubapi.com/crm/v3/objects/contacts/?archived=false&after=123456789&properties=hs_marketable_status"
//     }
//   }
// }
// ```
// 
// ### Error response
// ```json
// {
//   "message": "Uh oh! Hubspot returned with an error: Authentication credentials not found. This API supports OAuth 2.0 authentication and you can find more details at https://developers.hubspot.com/docs/methods/auth/oauth-overview"
// }
// ```
// ## Example
// ### Input
// ```json
// {
//   "after": 0,
//   "properties": [
//     "hs_marketable_status"
//   ]
// }
// ```
// ### Output
// ```json
// {
//   "results": [
//     {
//       "id": "12345",
//       "properties": {
//         "createdate": "2024-09-12T11:36:05.267Z",
//         "hs_marketable_status": "false",
//         "hs_object_id": "57309372733",
//         "lastmodifieddate": "2024-09-12T11:36:22.982Z"
//       },
//       "createdAt": "2024-09-12T11:36:05.267Z",
//       "updatedAt": "2024-09-12T11:36:22.982Z",
//       "archived": false
//     },
//     .
//     .
//     .
//   ],
//   "paging": {
//     "next": {
//       "after": "1234",
//       "link": "https://api.hubapi.com/crm/v3/objects/contacts/?archived=false&after=12345&properties=hs_marketable_status"
//     }
//   }
// }
// ```
function "Hubspot -> List Contacts" {
  input {
    int after?
    text[] properties? filters=trim
  }

  stack {
    // Hubspot API Request
    group {
      stack {
        api.request {
          url = "https://api.hubapi.com/crm/v3/objects/contacts/?archived=false" ~ ($var.after? "": "&after=" ~ $input.after) ~ "&properties=" ~ ($input.properties|join:",")
          method = "GET"
          params = {}|set:"archived":"false"
          headers = []
            |push:("authorization: Bearer %s"|sprintf:$env.hubspot_api_key)
        } as $hubspot_api
      }
    }
  
    precondition ($hubspot_api.response.status == 200) {
      error = "Uh oh! Hubspot returned with an error: %s"
        |sprintf:$hubspot_api.response.result.message
    }
  }

  response = $hubspot_api.response.result
}