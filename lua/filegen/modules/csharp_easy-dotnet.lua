
local M = {}

---@param path string
---@param done_callback function
local function handle_module_call(path, done_callback)
  vim.notify("CSharp called. Path: " .. path)
  done_callback()
end

function M.register()
 local module = require("filegen.handler.module")

 if not module.is_module_registered("easy-dotnet") then
   module.register_module({
      name = "C# - Easy Dotnet",
      type = "csharp_easy-dotnet",
      lsp_name = { 'easy_dotnet', 'csharp_ls', 'ominsharp', 'ominsharp-mono' },
      plugin = "easy-dotnet",
      handle_module_call = handle_module_call
    })
 end
end


return M
