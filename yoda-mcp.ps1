$quotes = @(
  "Do or do not, there is no try.",
  "Patience you must have, my young Padawan.",
  "Fear leads to anger; anger leads to hate; hate leads to suffering.",
  "The greatest teacher, failure is.",
  "Truly wonderful, the mind of a child is.",
  "In a dark place we find ourselves, and a little more knowledge lights our way.",
  "Size matters not. Judge me by my size, do you?",
  "Always pass on what you have learned."
)

while ($null -ne ($line = [Console]::In.ReadLine())) {
  if ([string]::IsNullOrWhiteSpace($line)) { continue }

  try {
    $msg = $line | ConvertFrom-Json
  } catch {
    continue
  }

  # Ignore JSON-RPC notifications (messages without an id)
  if ($null -eq $msg.id) { continue }

  $result = switch ($msg.method) {
    "initialize" {
      @{
        protocolVersion = "2024-11-05"
        capabilities    = @{ tools = @{} }
        serverInfo      = @{ name = "yoda-mcp"; version = "1.0.0" }
      }
    }
    "tools/list" {
      @{
        tools = @(
          @{
            name        = "get_yoda_quote"
            description = "Returns a random Yoda quote of wisdom."
            inputSchema = @{
              type       = "object"
              properties = @{}
            }
          }
        )
      }
    }
    "tools/call" {
      if ($msg.params.name -eq "get_yoda_quote") {
        $selected = $quotes | Get-Random
        @{
          content = @(
            @{
              type = "text"
              text = $selected
            }
          )
        }
      } else {
        @{
          isError = $true
          content = @(
            @{
              type = "text"
              text = "Unknown tool requested."
            }
          )
        }
      }
    }
    default { @{} }
  }

  $response = @{
    jsonrpc = "2.0"
    id      = $msg.id
    result  = $result
  } | ConvertTo-Json -Depth 10 -Compress

  [Console]::Out.WriteLine($response)
  [Console]::Out.Flush()
}