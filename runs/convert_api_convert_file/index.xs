workspace convert_api_convert_file {
  env = {convert_api_secret: ""}
}
---
// # Function Documentation: Convert Api -> File Convert
// [Convert API documentation](https://www.convertapi.com/doc)
// 
// 
// ## Overview
// This function stack handles file conversion using ConvertAPI. The function allows users to input a file URL, specify the `from_format`, `to_format`, and `file_url` and returns the converted file's URL.
// 
// ## Inputs
// 
// 1. **convert_api_key** (registry/text) *Required*
//    - **Description:** The API key used for authenticating the Convert API.
//    - **Example:** `xkeysib-...`
// 
// 2. **from_format** (enum) *Required*
//    - **Check Valid Format:** 
//    - **Description:** The format to convert from (e.g., png, jpg, pdf, doc, xls, csv).
//    - **Example:** `pdf`
// 
// 3. **to_format** (enum) *Required*
//    - **Description:** The format to convert to (e.g., png, jpg, pdf, doc, xls, csv).
//    - **Example:** `jpg`
// 
// 4. **file_url** (text) *Required*
//    - **Description:** The URL of the file to be converted.
//    - **Example:** `https://example.com/sample.jpg`
// 
// ## Function Stack
// 
// ### 1. Try / Catch Block
// 
// #### 1. Precondition: Checks File Format
//    - **Description:** It checks from format should be same as to format.
// 
// #### 2. API Request to https://v2.convertapi.com/convert/`{from_format}`/to/`{to_format}`
//    - **Purpose:** Converts the file from the `from_format` to the `to_format` using the file URL.
//    - **Return Value:** The API response is stored as `api_response`.
// 
// #### 3. Create Variable: `response`
//    - **Variable:** `var: response = var: api_response.response.result` 
//    - **Purpose:** Stores the API response for the convert api .
// 
// ### 2 Error Handling (Catch)
// 
// #### 1. Create Variable: `response`
//    - **Purpose:** If the API call fails or returns an error, this block catches the error and provides an error message.
// 
// ## Response
// 
// The function returns the URL of the converted file from ConvertAPI, including success or error messages.
// 
// ### Success Response
// ```json
// {
//    "ConversionCost": 1,
//    "Files": [
//       {
//          "FileName": "0266554465.pdf",
//          "FileExt": "pdf",
//          "FileSize": 63923,
//          "FileId": "wtj3krv14y87qzcoptgr9ytoj4a8evqx",
//          "Url": "https://v2.convertapi.com/d/wtj3krv14y87qzcoptgr9ytoj4a8evqx/0266554465.pdf"
//       }
//    ]
// }
// ```
// 
// ### Error Response
// 
// ```json
// {
//   "code": "invalid_parameter",
//   "message": "Unable to convert file. The provided file format is not supported."
// }
// ```
// 
// ## Example
// 
// ### Input
// ```json
// {
//     "from_format": "pdf",
//     "to_format": "jpg",
//     "file_url": "https://example.com/sample.pdf"
// }
// ```
// 
// ### Output
// ```json
// {
//    "ConversionCost": 1,
//    "Files": [
//       {
//          "FileName": "0266554465.pdf",
//          "FileExt": "pdf",
//          "FileSize": 63923,
//          "FileId": "wtj3krv14y87qzcoptgr9ytoj4a8evqx",
//          "Url": "https://v2.convertapi.com/d/wtj3krv14y87qzcoptgr9ytoj4a8evqx/0266554465.pdf"
//       }
//    ]
// }
// ```
function "$main" {
  input {
    object args {
      schema {
        enum from_format {
          values = ["pdf", "docx", "css", "xlsx", "jpg"]
        }
      
        enum to_format? {
          values = ["pdf", "docx", "css", "xlsx", "jpg"]
        }
      
        text file_url filters=trim
      }
    }
  }

  stack {
    try_catch {
      try {
        // From Format should not be same as to format
        precondition ($input.from_format != $input.to_format) {
          error_type = "badrequest"
          error = "Invalid Format conversion. from_format cannot be same as to_format."
        }
      
        // Convert API request
        api.request {
          url = "https://v2.convertapi.com/convert/%s/to/%s"
            |sprintf:$input.from_format:$input.to_format
          method = "POST"
          params = {}
            |set:"File":$input.file_url
            |set:"StoreFile":"true"
          headers = []
            |push:("Authorization: Bearer %s"|sprintf:$env.convert_api_secret)
        } as $api1
      
        // Response variable
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