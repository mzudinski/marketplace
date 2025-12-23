function "Gemini -> Chat with PDF" {
  input {
    text file_uri filters=trim
    text question filters=trim
  }

  stack {
    // Talk to Uploaded Content
    group {
      stack {
        api.request {
          url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=YOUR_API_KEY"
            |replace:"YOUR_API_KEY":$reg.gemini_api_key
          method = "POST"
          params = {}
            |set:"contents":([]
              |push:({}
                |set:"parts":([]
                  |push:({}|set:"text":$input.question)
                  |push:({}
                    |set:"file_data":({}
                      |set:"mime_type":"application/pdf"
                      |set:"file_uri":("FILE_URI_FROM_STEP_2"
                        |replace:"FILE_URI_FROM_STEP_2":$input.file_uri
                      )
                    )
                  )
                )
              )
            )
          headers = []
            |push:"Content-Type: application/json"
        } as $gemini_api
      }
    }
  
    precondition ($gemini_api.response.status == 200) {
      error = "Oops! The Gemini API responded with an error! Error code: %s"
        |sprintf:$gemini_api.response.status
    }
  }

  response = $gemini_api.response.result
}