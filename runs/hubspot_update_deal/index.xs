workspace hubspot_update_deal {
  env = {hubspot_api_key: ""}
}
---
// # HubSpot → Edit Deal
// 
// ## Overview
// This function allows you to edit an existing deal in HubSpot using specified input parameters. It involves setting environment variables, preparing the request with updated deal details, and handling the response from the HubSpot API.
// 
// ## Inputs
// 1. **hubspot_api_key** (registry|text) *Required* *Sensitive data*
//    - **Description:** The API key for your HubSpot account.
// 
// 2. **name** (text)
//    - **Description:** The updated name of the deal.
// 
// 3. **deal_stage** (enum)
//    - **Description:** The updated stage of the deal.
//     - **Options**
//         - `appointmentscheduled`
//         - `qualifiedtobuy`
//         - `presentationscheduled`
//         - `decisionmakerboughtin`
//         - `contractsent`
//         - `closedwon`
//         - `closedlost`
// 
// 4. **close_date** (timestamp)
//    - **Description:** The updated expected close date of the deal in unix timestamp format in milliseconds.
// 
// 5. **owner_id** (integer)
//    - **Description:** The updated ID of the owner of the deal.
// 
// 6. **amount** (decimal)
//    - **Description:** The updated amount associated with the deal.
// 
// 7. **deal_id** (text)
//    - **Description:** The unique identifier of the deal to be edited.
// 
// 8. **additional_properties** (json)
//    - **Description:** Additional properties in JSON format to be updated.
// 
// ## Function Stack
// ### 1. Create Properties Object
// 1. **Create Variable: `properties_obj`**
//    - **Purpose:** Sets properties object from `input: additional_properties` and other input fields.
// 
// ### 2. HubSpot API Request
// 1. **API Request to `https://api.hubapi.com/crm/v3/objects/deals/{deal_id}`**
//    - **Purpose:** Sends a PATCH request to update the specified deal in HubSpot.
// 
// ### 3. Preconditions
// 1. **Precondition: `hubspot_api.response.status == 200`**
//    - **Purpose:** Ensures successful update of the deal with HTTP status code 200.
// 
// ## Response
// - The function returns the result from the HubSpot API response.
// 
// ### Success response
// ```json
// {
//   "name": "Xano Actions",
//   "deal_stage": "qualifiedtobuy",
//   "close_date": 1729771263000,
//   "owner_id": 0,
//   "amount": 1456.55,
//   "additional_properties": 
//   {
//     "closed_won_reason": "Quick deployment"
//   },
//   "deal_id": "22413038713"
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
//   "name": "Xano Actions",
//   "deal_stage": "qualifiedtobuy",
//   "close_date": 1729771263000,
//   "owner_id": 0,
//   "amount": 1456.55,
//   "additional_properties": 
//   {
//     "closed_won_reason": "Quick deployment"
//   },
//   "deal_id": "22413038713"
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
    text name? filters=trim
    enum deal_stage? {
      values = [
        "appointmentscheduled"
        "qualifiedtobuy"
        "presentationscheduled"
        "decisionmakerboughtin"
        "contractsent"
        "closedwon"
        "closedlost"
      ]
    }
  
    timestamp? close_date?
    int owner_id?
    decimal amount?
    json additional_properties?
    text deal_id filters=trim
  }

  stack {
    // Create properties object
    group {
      stack {
        var $properties_obj {
          value = ```
            $input.additional_properties
              |set_ifnotempty:"dealname":$input.name
              |set_ifnotempty:"dealstage":$input.deal_stage
              |set_ifnotempty:"closedate":$input.close_date
              |set_ifnotempty:"hubspot_owner_id":$input.owner_id
              |set_ifnotempty:"amount":$input.amount
            ```
        }
      }
    }
  
    // Hubspot API Request
    group {
      stack {
        api.request {
          url = "https://api.hubapi.com/crm/v3/objects/deals/"|concat:$input.deal_id:""
          method = "PATCH"
          params = {}
            |set:"objectWriteTraceId":(""|create_uid)
            |set:"properties":$properties_obj
          headers = []
            |push:("authorization: Bearer %s"|sprintf:$env.hubspot_api_key)
            |push:"content-type: application/json"
        } as $hubspot_api
      }
    }
  
    precondition ($hubspot_api.response.status == 200) {
      error = "Uh oh! Hubspot returned with an error: %s"
        |sprintf:($hubspot_api.response.result|get:"message":null)
    }
  }

  response = $hubspot_api.response.result
}