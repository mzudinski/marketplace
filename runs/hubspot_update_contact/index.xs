workspace hubspot_update_contact {
  env = {hubspot_api_key: ""}
}
---
// # Function Documentation: HubSpot → Edit Contact
// 
// ## Overview
// This function allows you to edit an existing contact in HubSpot using specified input parameters. It involves setting environment variables, preparing the request with updated information, and handling the response from the HubSpot API.
// 
// ## Inputs
// 1. **hubspot_api_key** (registry|text) *Required* *Sensitive data*
//    - **Description:** The API key for your HubSpot account. 
// 
// 2. **first_name** (text)
//    - **Description:** The updated first name of the contact.
// 
// 3. **last_name** (text)
//    - **Description:** The updated last name of the contact.
// 
// 4. **email** (email)
//    - **Description:** The updated email address of the contact.
// 
// 5. **company** (text)
//    - **Description:** The updated company associated with the contact.
// 
// 6. **lead_status** (enum)
//    - **Description:** The updated lead status of the contact.
//     - **Options:** 
//       - `NEW`
//       - `OPEN`
//       - `IN_PROGRESS`
//       - `OPEN_DEAL`
//       - `UNQUALIFIED`
//       - `ATTEMPTED_TO_CONTACT`
//       - `CONNECTED`
//       - `BAD_TIMING`
// 
// 7. **contact_owner** (integer)
//    - **Description:** The updated owner of the contact.
// 
// 8. **phone_number** (text)
//    - **Description:** The updated phone number of the contact.
// 
// 9. **contact_id** (integer)
//    - **Description:** The unique identifier of the contact to be edited.
// 
// 10. **additional_properties** (json)
//    - **Description:** Additional properties in JSON format to be updated.
//     - **Schema:** 
//         ```json
//         {
//             "additionalProp1": "string",
//             "additionalProp2": "string",
//             "additionalProp3": "string"
//         }
//         ```
//    - > [❗] You can clear a property value by passing an empty string. Example: `{"company":""}` . This will clear the value stored in the company field.
// 
// ## Function Stack
// ### 1. Set Properties Object
// 1. **Create Variable: `properties_object`**
//    - **Purpose:** Sets properties object from `input: additional_properties` and other input fields.
// 
// ### 2. HubSpot API Request
// 1. **API Request to `https://api.hubapi.com/crm/v3/objects/contacts/{contact_id}`**
//    - **Purpose:** Sends a PATCH request to update the specified contact in HubSpot.
// 
// ### 3. Create Variable
// 1. **Create Variable: `inputss`**
//    - **Purpose:** Checks if the company input is null.
// 
// ### 4. Preconditions
// 1. **Precondition: `hubspot_api.response.status == 200`**
//    - **Purpose:** Ensures successful update of the contact with HTTP status code 200.
// 
// ## Response
// - The function returns the result from the HubSpot API response.
// 
// ### Success response
// ```json
// {
//   "id": "123456789",
//   "properties": {
//     "company": "Xano",
//     .
//     .
//     .
//     "phone": "42"
//   },
//   "createdAt": "2024-09-16T12:11:28.596Z",
//   "updatedAt": "2024-09-23T13:41:47.246Z",
//   "archived": false
// }
// ```
// 
// ### Error message
// ```json
// {
//     "message":"Uh oh! Hubspot returned with an error: Property values were not valid: [{\"isValid\":false,\"message\":\"Property \\\"prop2\\\" does not exist\",\"error\":\"PROPERTY_DOESNT_EXIST\",\"name\":\"prop2\",\"localizedErrorMessage\":\"Property \\\"prop2\\\" does not exist\",\"portalId\":47373842},{\"isValid\":false,\"message\":\"Property \\\"prop1\\\" does not exist\",\"error\":\"PROPERTY_DOESNT_EXIST\",\"name\":\"prop1\",\"localizedErrorMessage\":\"Property \\\"prop1\\\" does not exist\",\"portalId\":47373842}]"
// }
// ```
// 
// ## Example
// ### Input
// ```json
// {
//   "first_name": "Xano",
//   "last_name": "Actions",
//   "email": "actions@xano.com",
//   "company": "Xano",
//   "lead_status": "OPEN_DEAL",
//   "contact_owner": 0,
//   "phone_number": "42",
//   "contact_id": 123456789,
//   "additional_properties": {
//     "mobilephone":"1024"
//   }
// ```
// ### Output
// ```json
// {
//   "id": "123456789",
//   "properties": {
//     "company": "Xano",
//     .
//     .
//     .
//     "phone": "42"
//   },
//   "createdAt": "2024-09-16T12:11:28.596Z",
//   "updatedAt": "2024-09-23T13:41:47.246Z",
//   "archived": false
// }
// ```
function "$main" {
  input {
    object args {
      schema {
        text first_name? filters=trim
        text last_name? filters=trim
        email email? filters=trim|lower
        text company? filters=trim
        enum lead_status? {
          values = [
            "NEW"
            "OPEN"
            "IN_PROGRESS"
            "OPEN_DEAL"
            "UNQUALIFIED"
            "ATTEMPTED_TO_CONTACT"
            "CONNECTED"
            "BAD_TIMING"
          ]
        }
      
        int contact_owner?
        text phone_number? filters=trim
        int contact_id
        json additional_properties?
      }
    }
  }

  stack {
    // Create Properties Object
    group {
      stack {
        var $properties_object {
          value = ```
            $input.additional_properties
                |set_ifnotempty:"firstname":$input.first_name
                |set_ifnotempty:"lastname":$input.last_name
                |set_ifnotempty:"email":$input.email
                |set_ifnotempty:"company":$input.company
                |set_ifnotempty:"hs_lead_status":$input.lead_status
                |set_ifnotempty:"hubspot_owner_id":$input.contact_owner
                |set_ifnotempty:"phone":$input.phone_number
            ```
        }
      }
    }
  
    // Hubspot API Request
    group {
      stack {
        api.request {
          url = "https://api.hubapi.com/crm/v3/objects/contacts/"|concat:$input.contact_id:""
          method = "PATCH"
          params = {}
            |set:"objectWriteTraceId":(""|create_uid)
            |set:"properties":$properties_object
          headers = []
            |push:("authorization: Bearer %s"|sprintf:$env.hubspot_api_key)
            |push:"content-type: application/json"
        } as $hubspot_api
      }
    }
  
    var $inputss {
      value = $input.company|is_null
    }
  
    precondition ($hubspot_api.response.status == 200) {
      error = "Uh oh! Hubspot returned with an error: %s"
        |sprintf:($hubspot_api.response.result|get:"message":null)
    }
  }

  response = $hubspot_api.response.result
}