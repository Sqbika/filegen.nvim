---@class FilegenConfig
---@field enable_builtin? boolean | BuiltinConfig Enable builtin definitions. False disables all. Default true
---@field picker "auto" | "telescope" | string Picker type to use for selection. 
---@field picker_definitions? RegisteredPickers Custom pickers to register
---@field module_definitions? RegisteredModules Custom modules to register

---@class BuiltinConfig
---@field pickers boolean Enable builtin picker definitions
---@field modules boolean Enable builtin module definitions

local M = {}

---@type FilegenConfig
M.config = {
  picker = "auto",
  enable_builtin = true,
  picker_definitions = nil,
  module_definitions = nil,
}

---@param opts? FilegenConfig
function M.setup_config(opts)
  M.config = vim.tbl_deep_extend(
    "force",
      M.config,
    opts or {}
  )
end

return M
