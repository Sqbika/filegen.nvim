---@type RegisteredPickers
local registered_pickers = {}

local M = {}

---@param picker RegisteredPicker
function M.register_picker(picker)
  for k, v in ipairs(registered_pickers) do
    if v.name == picker.name then
      table.remove(registered_pickers, k)
      table.insert(registered_pickers, k, picker)
      return
    end
  end

  table.insert(registered_pickers, picker)
end

---@param opts FilegenConfig
---@param rows TemplateTypes
---@param selection_callback SelectionCallback
function M.open_picker(opts, rows, selection_callback)
  local picker = (opts and opts.picker) or "auto"

  ---@type RegisteredPicker?
  local selected_picker = nil

  if picker ~= "auto" then
    local found = false
    for _,v in ipairs(registered_pickers) do
      if v.name == picker then
        selected_picker = v
        found = true
        break
      end
    end
    if found == false then
      vim.notify("No registered picker found: " .. picker, vim.log.levels.ERROR)
      return nil
    end
  else
    _, selected_picker = next(registered_pickers)
  end

  if selected_picker == nil then
    vim.notify("No registered pickers found.", vim.log.levels.WARN)
    return nil
  end

  return selected_picker.fn_open(rows, selection_callback)
end

return M
