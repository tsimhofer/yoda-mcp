# yoda-mcp

A minimal Model Context Protocol (MCP) server written in PowerShell that provides a single tool:

- **`get_yoda_quote`** — Returns a random Yoda quote of wisdom.

## How it works

The server ([yoda-mcp.ps1](yoda-mcp.ps1)) speaks JSON-RPC over stdio, following the MCP protocol (version `2024-11-05`). It handles the `initialize`, `tools/list`, and `tools/call` methods and responds to each request with a JSON-RPC result.

## Usage

Add the server to your MCP client configuration (e.g., `.mcp.json`):

```json
{
  "mcpServers": {
    "yoda-mcp": {
      "type": "stdio",
      "command": "powershell.exe",
      "args": ["-File", "yoda-mcp.ps1"]
    }
  }
}
```

Then call the `get_yoda_quote` tool to receive a random quote, for example:

> "Do or do not, there is no try."

## Requirements

- Windows PowerShell (uses `[Console]::In`/`[Console]::Out` for stdio I/O)
