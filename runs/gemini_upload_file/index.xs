run.job "Gemini -> Upload File" {
  main = {
    name : "Gemini -> Upload File"
    input: {file: "uploaded_file"}
  }

  env = ["gemini_api_key"]
}
---
function "Gemini -> Upload File" {
  input {
    file? file
  }

  stack {
    storage.read_file_resource {
      value = $input.file
    } as $file_resource
  
    // Initiate Upload
    group {
      stack {
        api.request {
          url = "https://generativelanguage.googleapis.com/upload/v1beta/files?key=YOUR_KEY"
            |replace:"YOUR_KEY":$env.gemini_api_key
          method = "POST"
          params = {}
            |set:"file":({}
              |set:"display_name":$file_resource
            )
          headers = []
            |push:"X-Goog-Upload-Protocol: resumable"
            |push:"X-Goog-Upload-Command: start"
            |push:("X-Goog-Upload-Header-Content-Length: SIZE_BYTES"
              |replace:"SIZE_BYTES":$file_resource.size
            )
            |push:"X-Goog-Upload-Header-Content-Type: application/pdf"
            |push:"Content-Type: application/json"
        } as $upload_api
      }
    }
  
    // Extract URL from upload_api Header Response
    group {
      stack {
        var $upload_url {
          value = $upload_api.response.headers|entries
        }
      }
    }
  
    // Upload File to Returned URL
    group {
      stack {
        api.request {
          url = $upload_url.4.value|replace:"x-goog-upload-url: ":""
          method = "POST"
          params = {}|set:"":$file_resource.data
          headers = []
            |push:("Content-Length: FILE_SIZE_IN_BYTES"
              |replace:"FILE_SIZE_IN_BYTES":$file_resource.size
            )
            |push:"X-Goog-Upload-Offset: 0"
            |push:"X-Goog-Upload-Command: upload, finalize"
        } as $uploaded_file
      }
    }
  }

  response = $uploaded_file.response.result.file.uri
}