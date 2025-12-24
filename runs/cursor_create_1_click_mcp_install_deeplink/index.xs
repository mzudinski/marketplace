run "Cursor -> Create 1-click MCP Install Deeplink" {
  type = "job"
  main = {
    name : "Cursor -> Create 1-click MCP Install Deeplink"
    input: {
      mcp_server_url: "https://x123-wu0q-dtak.n7.xano.io/x2/mcp/6vi_VA6-/mcp/sse"
      server_name   : "Xano MCP Server Name"
      server_type   : "sse"
    }
  }
}
---
// A helper function that creates a 1-click MCP install link for Cursor using URL-based authentication with Xano MCP Servers. This function generates deeplinks and various markup formats (Markdown, HTML, JSX) that allow users to install MCP servers directly into Cursor with a single click.
// 
// ## Input Parameters
// 
// | Parameter | Type | Required | Description |
// |-----------|------|----------|-------------|
// | `mcp_server_url` | string | Yes | The full URL endpoint of the Xano MCP server |
// | `server_name` | string | Yes | Display name for the MCP server |
// | `server_type` | enum | Yes | Type of MCP server connection |
// 
// ## Example Input
// 
// ```json
// {
//   "mcp_server_url": "https://x123-wu0q-dtak.n7.xano.io/x2/mcp/6vi_VA6-/mcp/sse",
//   "server_name": "Xano MCP Server Name", 
//   "server_type": "sse"
// }
// ```
// 
// ## Example Output
// 
// ```json
// {
//   "deeplink": "cursor://anysphere.cursor-deeplink/mcp/install?name=Xano MCP Server Name&config=eyJ0eXBlIjoic3NlIiwidXJsIjoiaHR0cHM6Ly94MTIzLXd1MHEtZHRhay5uNy54YW5vLmlvL3gyL21jcC82dmlfVkE2LS9tY3Avc3NlIn0=",
//   "markdown": {
//     "dark": "[![Install MCP Server](https://cursor.com/deeplink/mcp-install-dark.svg)](cursor%3A%2F%2Fanysphere.cursor-deeplink%2Fmcp%2Finstall%3Fname%3DXano%20MCP%20Server%20Name%26config%3DeyJ0eXBlIjoic3NlIiwidXJsIjoiaHR0cHM6Ly94MTIzLXd1MHEtZHRhay5uNy54YW5vLmlvL3gyL21jcC82dmlfVkE2LS9tY3Avc3NlIn0%3D)",
//     "light": "[![Install MCP Server](https://cursor.com/deeplink/mcp-install-light.svg)](cursor%3A%2F%2Fanysphere.cursor-deeplink%2Fmcp%2Finstall%3Fname%3DXano%20MCP%20Server%20Name%26config%3DeyJ0eXBlIjoic3NlIiwidXJsIjoiaHR0cHM6Ly94MTIzLXd1MHEtZHRhay5uNy54YW5vLmlvL3gyL21jcC82dmlfVkE2LS9tY3Avc3NlIn0%3D)"
//   },
//   "html": {
//     "dark": "<a href=\"cursor&#x3A;&#x2F;&#x2F;anysphere.cursor-deeplink&#x2F;mcp&#x2F;install&#x3F;name&#x3D;Xano&#x20;MCP&#x20;Server&#x20;Name&amp;config&#x3D;eyJ0eXBlIjoic3NlIiwidXJsIjoiaHR0cHM6Ly94MTIzLXd1MHEtZHRhay5uNy54YW5vLmlvL3gyL21jcC82dmlfVkE2LS9tY3Avc3NlIn0&#x3D;\"><img src=\"https://cursor.com/deeplink/mcp-install-dark.svg\" alt=\"Add Xano&#x20;MCP&#x20;Server&#x20;Name MCP server to Cursor\" height=\"32\" /></a>",
//     "light": "<a href=\"cursor&#x3A;&#x2F;&#x2F;anysphere.cursor-deeplink&#x2F;mcp&#x2F;install&#x3F;name&#x3D;Xano&#x20;MCP&#x20;Server&#x20;Name&amp;config&#x3D;eyJ0eXBlIjoic3NlIiwidXJsIjoiaHR0cHM6Ly94MTIzLXd1MHEtZHRhay5uNy54YW5vLmlvL3gyL21jcC82dmlfVkE2LS9tY3Avc3NlIn0&#x3D;\"><img src=\"https://cursor.com/deeplink/mcp-install-light.svg\" alt=\"Add Xano&#x20;MCP&#x20;Server&#x20;Name MCP server to Cursor\" height=\"32\" /></a>"
//   },
//   "jsx": {
//     "dark": "<a href=\"cursor&#x3A;&#x2F;&#x2F;anysphere.cursor-deeplink&#x2F;mcp&#x2F;install&#x3F;name&#x3D;Xano&#x20;MCP&#x20;Server&#x20;Name&amp;config&#x3D;eyJ0eXBlIjoic3NlIiwidXJsIjoiaHR0cHM6Ly94MTIzLXd1MHEtZHRhay5uNy54YW5vLmlvL3gyL21jcC82dmlfVkE2LS9tY3Avc3NlIn0&#x3D;\"><img src=\"https://cursor.com/deeplink/mcp-install-dark.svg\" alt=\"Add Xano&#x20;MCP&#x20;Server&#x20;Name MCP server to Cursor\" height=\"32\" /></a>",
//     "light": "<a href=\"cursor&#x3A;&#x2F;&#x2F;anysphere.cursor-deeplink&#x2F;mcp&#x2F;install&#x3F;name&#x3D;Xano&#x20;MCP&#x20;Server&#x20;Name&amp;config&#x3D;eyJ0eXBlIjoic3NlIiwidXJsIjoiaHR0cHM6Ly94MTIzLXd1MHEtZHRhay5uNy54YW5vLmlvL3gyL21jcC82dmlfVkE2LS9tY3Avc3NlIn0&#x3D;\"><img src=\"https://cursor.com/deeplink/mcp-install-light.svg\" alt=\"Add Xano&#x20;MCP&#x20;Server&#x20;Name MCP server to Cursor\" height=\"32\" /></a>"
//   }
// }
// ```
// 
// ## Output Fields
// 
// ### `deeplink`
// The raw Cursor deeplink URL that can be used programmatically or shared directly.
// 
// ### `markdown`
// Ready-to-use Markdown install buttons with Cursor's official badge images:
// - `dark`: Dark theme install button
// - `light`: Light theme install button
// 
// ### `html` 
// HTML anchor tags with embedded install buttons:
// - `dark`: Dark theme HTML button
// - `light`: Light theme HTML button
// 
// ### `jsx`
// JSX-compatible HTML for React components:
// - `dark`: Dark theme JSX button  
// - `light`: Light theme JSX button
// 
// ## Usage Notes
// 
// - The `config` parameter in the deeplink contains a base64-encoded JSON configuration
// - All markup formats include proper URL encoding for compatibility
// - The function supports both dark and light theme variants for different UI contexts
// - Install buttons use Cursor's official badge images hosted at `cursor.com/deeplink/`
// 
// ## Implementation Details
// 
// The function creates a Cursor deeplink following the format:
// ```
// cursor://anysphere.cursor-deeplink/mcp/install?name={SERVER_NAME}&config={BASE64_CONFIG}
// ```
// 
// Where `{BASE64_CONFIG}` is a base64-encoded JSON object containing:
// ```json
// {
//   "type": "{server_type}",
//   "url": "{mcp_server_url}"
// }
// ```
function "Cursor -> Create 1-click MCP Install Deeplink" {
  input {
    text mcp_server_url filters=trim
    text server_name? filters=trim
    enum server_type?=sse {
      values = ["sse", "streamable-http"]
    }
  }

  stack {
    util.template_engine {
      value = '{"type":"{{$input.server_type}}","url":"{{$input.mcp_server_url}}"}'
    } as $base64_encoded_config|base64_encode
  
    var $formatted_url {
      value = "cursor://anysphere.cursor-deeplink/mcp/install?name=$NAME&config=$BASE64_ENCODED_CONFIG"
        |replace:"$NAME":$input.server_name
        |replace:"$BASE64_ENCODED_CONFIG":$base64_encoded_config
    }
  
    util.template_engine {
      value = """
        {
            "dark": "[![Install MCP Server](https://cursor.com/deeplink/mcp-install-dark.svg)]({{$var.formatted_url|url_encode}})|json_encode",
            "light": "[![Install MCP Server](https://cursor.com/deeplink/mcp-install-light.svg)]({{$var.formatted_url|url_encode}})"
        }
        """
    } as $Markdown|json_decode
  
    util.template_engine {
      value = """
        {% set dark_html %}
        <a href="{{ $var.formatted_url|e('html_attr') }}"><img src="https://cursor.com/deeplink/mcp-install-dark.svg" alt="Add {{ $input.server_name|e('html_attr') }} MCP server to Cursor" height="32" /></a>
        {% endset %}
        
        {% set light_html %}
        <a href="{{ $var.formatted_url|e('html_attr') }}"><img src="https://cursor.com/deeplink/mcp-install-light.svg" alt="Add {{ $input.server_name|e('html_attr') }} MCP server to Cursor" height="32" /></a>
        {% endset %}
        
        {
            "dark": {{ dark_html|json_encode }},
            "light": {{ light_html|json_encode }}
        }
        """
    } as $HTML|json_decode
  
    util.template_engine {
      value = """
        {% set dark_html %}
        <a href="{{ $var.formatted_url|e('html_attr') }}"><img src="https://cursor.com/deeplink/mcp-install-dark.svg" alt="Add {{ $input.server_name|e('html_attr') }} MCP server to Cursor" height="32" /></a>
        {% endset %}
        
        {% set light_html %}
        <a href="{{ $var.formatted_url|e('html_attr') }}"><img src="https://cursor.com/deeplink/mcp-install-light.svg" alt="Add {{ $input.server_name|e('html_attr') }} MCP server to Cursor" height="32" /></a>
        {% endset %}
        
        {
            "dark": {{ dark_html|json_encode }},
            "light": {{ light_html|json_encode }}
        }
        """
    } as $JSX|json_decode
  }

  response = {
    deeplink: $formatted_url
    markdown: $Markdown
    html    : $HTML
    jsx     : $JSX
  }
}