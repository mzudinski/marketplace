// Here is the updated documentation for your new `create_spreadsheet` function:
// 
// ---
// 
// # Create Spreadsheet
// 
// Creates a new Google Spreadsheet using the Sheets API.
// 
// ### Inputs
// 
// | Name         | Type | Required | Description                                                                                   |
// | :----------- | :--- | :------- | :-------------------------------------------------------------------------------------------- |
// | title        | text | Yes      | The title of the new spreadsheet.                                                             |
// | access_token | text | Yes      | Google OAuth2 Access Token for authentication. Install the template [here](https://www.xano.com/snippet/fycpNWmW/) |
// 
// ### Function Stack
// 
// 1. **Build Properties**
//    - Constructs the spreadsheet properties object (currently only `title`).
// 2. **API Request**
//    - Calls the Google Sheets API to create a new spreadsheet.
//    - Endpoint:  
//      `POST https://sheets.googleapis.com/v4/spreadsheets`
//    - Payload:
//      ```json
//      {
//        "properties": {
//          "title": "My Spreadsheet"
//        }
//      }
//      ```
//    - Authenticates using the provided access token.
// 3. **Precondition**
//    - Checks for a successful (status 200) response.
//    - Throws an error if the API response is not successful.
// 4. **Extract Spreadsheet ID**
//    - Parses the API response for the new spreadsheet's ID.
// 5. **Extract Spreadsheet URL**
//    - Parses the API response for the new spreadsheet's URL.
// 
// ### Response
// 
// Returns:
// ```json
// {
//   "spreadsheet_id": "1A2B3C4D5E",
//   "spreadsheet_url": "https://docs.google.com/spreadsheets/d/1A2B3C4D5E/edit"
// }
// ```
// 
// ### Example Usage
// 
// **Request**
// ```json
// {
//   "title": "Team Roster",
//   "access_token": "ya29.a0AfH6SMB..."
// }
// ```
// 
// **Response**
// ```json
// {
//   "spreadsheet_id": "1A2B3C4D5E",
//   "spreadsheet_url": "https://docs.google.com/spreadsheets/d/1A2B3C4D5E/edit"
// }
// ```
// 
// ### Notes
// 
// - The spreadsheet title must be unique within your Google Drive.
// - The access token must have permission to create spreadsheets.
// 
// ### References
// 
// - [Google Sheets API: Create Spreadsheet](https://developers.google.com/sheets/api/reference/rest/v4/spreadsheets/create)
// - [Google Sheets API: Concepts](https://developers.google.com/workspace/sheets/api/guides/concepts)
// - [Google Sheets API: Reference](https://developers.google.com/sheets/api/reference/rest)
// 
// ---
// 
// ## Troubleshooting
// 
// - **PERMISSION_DENIED**: Check your access token and Google account permissions.
// - **INVALID_ARGUMENT**: Ensure all required fields are provided and valid.
// - **For more help**: Refer to the [Google Sheets API documentation](https://developers.google.com/sheets/api/guides/concepts).
function "Google Sheets -> Create Spreadsheet" {
  input {
    // The title of the new spreadsheet.
    text title
  }

  stack {
    // Build spreadsheet properties object.
    var $properties {
      value = {
        title   : $input.title,
      }|filter_null
    }
  
    // Call Google Sheets API to create a new spreadsheet with basic properties.
    api.request {
      url = "https://sheets.googleapis.com/v4/spreadsheets"
      method = "POST"
      params = {properties: $properties}
      headers = []
        |push:"Content-Type: application/json"
        |push:"Authorization: Bearer " ~ $reg.access_token
      verify_host = false
      verify_peer = false
    } as $create_response
  
    precondition ($create_response.response.status == 200) {
      error = "Uh oh! The Google API responded with an error: %s"
        |sprintf:($create_response.response.result
          |get:"error":null
          |get:"message":null
        )
      payload = $create_response.response.result.error
    }
  
    // ID of the newly created spreadsheet.
    var $spreadsheet_id {
      value = $create_response.response.result.spreadsheetId
    }
  
    // URL of the newly created spreadsheet.
    var $spreadsheet_url {
      value = $create_response.response.result.spreadsheetUrl
    }
  }

  response = {
    spreadsheet_id : $spreadsheet_id
    spreadsheet_url: $spreadsheet_url
  }
}