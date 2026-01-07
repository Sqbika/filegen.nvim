---@class FilegenConfig
---@field picker "auto" | "telescope" | string Picker type to use for selection. 

local M = {}

---@type FilegenConfig
M.config = {}

---@type FilegenConfig
M.defaults = {
  picker = "auto"
}

---@param opts? FilegenConfig
function M.setup_config(opts)
  M.config = vim.tbl_deep_extend(
    "force",
      M.defaults,
    opts or {}
  )
end

return M
