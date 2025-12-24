run "Google Sheets -> Update Values" {
  type = "job"
  main = {
    name : "Google Sheets -> Update Values"
    input: {
      spreadsheet_id    : "1A2B3C4D5E"
      range             : "Sheet1!A1:C3"
      values            : [
        ["Name", "Role", "Email"]
        ["Alice", "Manager", "alice@example.com"]
        ["Bob", "Developer", "bob@example.com"]
      ]
      value_input_option: "RAW"
      access_token      : "ya29.a0AfH6SMB..."
    }
  }

  env = ["access_token"]
}
---
// Updates values in a specific range of a Google Sheet using the Sheets API.
// 
// ### Inputs
// 
// | Name              | Type | Required | Description                                                                 |
// | :---------------- | :--- | :------- | :-------------------------------------------------------------------------- |
// | spreadsheet_id    | text | Yes      | The ID of the Google Spreadsheet.                                           |
// | range             | text | Yes      | The A1 notation of the range to update (e.g., 'Sheet1!A1:C10').            |
// | values            | json | Yes      | 2D array of values to update in the sheet.                                  |
// | value_input_option| text | No       | How the input data should be interpreted (`RAW` or `USER_ENTERED`). Default is `RAW`. |
// | access_token      | text | Yes      | Google OAuth2 access token for authentication.                              |
// 
// ### Function Stack
// 
// 1. **API Request**
//    - Calls the Google Sheets API to update values in the specified range.
//    - Endpoint:  
//      `PUT https://sheets.googleapis.com/v4/spreadsheets/{spreadsheet_id}/values/{range}?valueInputOption={value_input_option}`
//    - Payload:
//      ```json
//      {
//        "range": "Sheet1!A1:C10",
//        "majorDimension": "ROWS",
//        "values": [
//          ["Name", "Role", "Email"],
//          ["Alice", "Manager", "alice@example.com"],
//          ["Bob", "Developer", "bob@example.com"]
//        ]
//      }
//      ```
//    - Authenticates using the provided access token.
// 2. **Precondition**
//    - Checks for a successful (status 200) response.
//    - Throws an error if the API response is not successful.
// 3. **Extract Response Details**
//    - Parses the API response for update details.
// 
// ### Response
// 
// Returns the full API response, including updated range, rows, columns, and cells.
// 
// **Example Response**
// ```json
// {
//   "spreadsheetId": "1A2B3C4D5E",
//   "updatedRange": "Sheet1!A1:C3",
//   "updatedRows": 3,
//   "updatedColumns": 3,
//   "updatedCells": 9
// }
// ```
// 
// ### Example Usage
// 
// **Request**
// ```json
// {
//   "spreadsheet_id": "1A2B3C4D5E",
//   "range": "Sheet1!A1:C3",
//   "values": [
//     ["Name", "Role", "Email"],
//     ["Alice", "Manager", "alice@example.com"],
//     ["Bob", "Developer", "bob@example.com"]
//   ],
//   "value_input_option": "RAW",
//   "access_token": "ya29.a0AfH6SMB..."
// }
// ```
// 
// **Response**
// ```json
// {
//   "spreadsheetId": "1A2B3C4D5E",
//   "updatedRange": "Sheet1!A1:C3",
//   "updatedRows": 3,
//   "updatedColumns": 3,
//   "updatedCells": 9
// }
// ```
// 
// ### Notes
// 
// - The range must match the shape of the provided values.
// - The access token must have edit access to the spreadsheet.
// 
// ### References
// 
// - [Google Sheets API: Update Values](https://developers.google.com/sheets/api/reference/rest/v4/spreadsheets.values/update)
// - [Google Sheets API: Concepts](https://developers.google.com/workspace/sheets/api/guides/concepts)
// 
// ---
// 
// ## Troubleshooting
// 
// - **PERMISSION_DENIED**: Check your access token and spreadsheet permissions.
// - **INVALID_ARGUMENT**: Ensure all required fields are provided and valid.
// - **NOT_FOUND**: Verify the spreadsheet ID and range.
// - For more help, refer to the [Google Sheets API documentation](https://developers.google.com/sheets/api/guides/concepts).
// 
// ---
function "Google Sheets -> Update Values" {
  input {
    // The ID of the Google Spreadsheet.
    text spreadsheet_id
  
    // The A1 notation of the range to update (e.g., 'Sheet1!A1:C10').
    text range
  
    // 2D array of values to update in the sheet.
    json values
  
    // How the input data should be interpreted (RAW or USER_ENTERED). Default is RAW.
    text value_input_option?=RAW
  }

  stack {
    // Call Google Sheets API to update values in the specified range.
    api.request {
      url = "https://sheets.googleapis.com/v4/spreadsheets/" ~ $input.spreadsheet_id ~ "/values/" ~ $input.range ~ "?valueInputOption=" ~ $input.value_input_option
      method = "PUT"
      params = {
        range         : $input.range
        majorDimension: "ROWS"
        values        : $input.values
      }
    
      headers = []
        |push:"Content-Type: application/json"
        |push:"Authorization: Bearer " ~ $env.access_token
      verify_host = false
      verify_peer = false
    } as $update_response
  
    precondition ($update_response.response.status == 200) {
      error = "Uh oh! The Google API responded with an error: %s"
        |sprintf:($update_response.response.result
          |get:"error":null
          |get:"message":null
        )
      payload = "create_response.response.result.error"
    }
  
    // Full API response details.
    var $response_details {
      value = $update_response.response.result
    }
  }

  response = $response_details
}