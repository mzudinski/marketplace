// # Function Documentation: HubSpot → Create Contact
// ## Overview
// This function creates a new contact in HubSpot using specified input parameters. It involves setting environment variables, preparing the request, and handling the response.
// 
// ## Inputs
// 1. **hubspot_api_key** (registry|text)  *Required* *Sensitive data*
//    - **Description:** The API key for your HubSpot account.
// 
// 2. **first_name** (text)
//    - **Description:** The first name of the contact.
// 
// 3. **last_name** (text)
//    - **Description:** The last name of the contact.
// 
// 4. **email** (text)
//    - **Description:** The email address of the contact.
// 
// 5. **company** (text)
//    - **Description:** The company associated with the contact.
// 
// 6. **lead_status** (enum)
//    - **Description:** The lead status of the contact.
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
//    - **Description:** The owner of the contact.
// 
// 8. **phone_number** (text)
//    - **Description:** The phone number of the contact.
// 
// 9. **additional_properties** (json)
//    - **Description:** Additional properties in JSON format.
//     - **Schema:** 
//         ```json
//         {
//             "additionalProp1": "string",
//             "additionalProp2": "string",
//             "additionalProp3": "string"
//         }
//         ```
// 
// ## Function Stack
// ### 1. Set Properties Object
// 1. **Create Variable: `properties_object`**
//    - **Purpose:** Sets properties object from `input: additional_properties`.
// 
// ### 2. HubSpot API Request
// 1. **API Request to `https://api.hubapi.com/crm/v3/objects/contacts`**
//    - **Purpose:** Sends a POST request to create a new contact in HubSpot.
// 
// ### 3. Preconditions
// 1. **Precondition: `hubspot_api.response.status == 201`**
//    - **Purpose:** Ensures successful creation of the contact with HTTP status code 201.
// 
// ## Response
// - The function returns the result from the HubSpot API response.
// 
// ### Success response
// ```json
// {
//   "id": "12345678",
//   "properties": {
//     "company": "Xano",
//     .
//     .
//     .
//   },
//   "createdAt": "2024-09-23T13:26:23.352Z",
//   "updatedAt": "2024-09-23T13:26:23.352Z",
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
// **Input**
// ```json
// {
//   "first_name": "Unico",
//   "last_name": "Connect",
//   "email": "imagine@xano.com",
//   "company": "UC",
//   "lead_status": "OPEN",
//   "contact_owner": 0,
//   "phone_number": "123456",
//   "customer_Id": 0,
//   "additional_properties":
//   {
//     "mobilephone":"123456"
//   }
// }
// ```
// 
// **Output**
// ```json
// {
//   "id": "123456789",
//   "properties": {
//     "company": "UC",
//     "createdate": "2024-09-23T13:30:40.386Z",
//     "email": "imagine@xano.com",
//     "firstname": "Unico",
//     "hs_all_contact_vids": "60968500829",
//     "hs_currently_enrolled_in_prospecting_agent": "false",
//     "hs_email_domain": "xano.com",
//     "hs_is_contact": "true",
//     "hs_is_unworked": "true",
//     "hs_lead_status": "OPEN",
//     "hs_lifecyclestage_lead_date": "2024-09-23T13:30:40.386Z",
//     "hs_marketable_status": "false",
//     "hs_marketable_until_renewal": "false",
//     "hs_membership_has_accessed_private_content": "0",
//     "hs_object_id": "60968500829",
//     "hs_object_source": "INTEGRATION",
//     "hs_object_source_id": "3898752",
//     "hs_object_source_label": "INTEGRATION",
//     "hs_pipeline": "contacts-lifecycle-pipeline",
//     "hs_registered_member": "0",
//     "hs_searchable_calculated_mobile_number": "123456",
//     "hs_searchable_calculated_phone_number": "123456",
//     "lastmodifieddate": "2024-09-23T13:30:40.386Z",
//     "lastname": "Connect",
//     "lifecyclestage": "lead",
//     "mobilephone": "123456",
//     "phone": "123456"
//   },
//   "createdAt": "2024-09-23T13:30:40.386Z",
//   "updatedAt": "2024-09-23T13:30:40.386Z",
//   "archived": false
// }
// ```
function "Hubspot -> Create Contact" {
  input {
    text first_name? filters=trim
    text last_name? filters=trim
    email email filters=trim|lower
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
    json additional_properties?
  }

  stack {
    // Set properties object
    group {
      stack {
        var $properties_object {
          value = $input.additional_properties
            |set_ifnotempty:"firstname":$input.first_name
            |set_ifnotempty:"lastname":$input.last_name
            |set_ifnotempty:"email":$input.email
            |set_ifnotempty:"company":$input.company
            |set_ifnotempty:"hs_lead_status":$input.lead_status
            |set_ifnotempty:"contact_owner":$input.contact_owner
            |set_ifnotempty:"phone":$input.phone_number
        }
      }
    }
  
    // Hubspot API Request
    group {
      stack {
        api.request {
          url = "https://api.hubapi.com/crm/v3/objects/contacts"
          method = "POST"
          params = {}
            |set:"objectWriteTraceId":(""|create_uid)
            |set:"properties":$properties_object
          headers = []
            |push:("authorization: Bearer %s"|sprintf:"hubspot_api_key")
            |push:"content-type: application/json"
        } as $hubspot_api
      }
    }
  
    precondition ($hubspot_api.response.status == 201) {
      error = "Uh oh! Hubspot returned with an error: %s"
        |sprintf:$hubspot_api.response.result.message
    }
  }

  response = $hubspot_api.response.result
}