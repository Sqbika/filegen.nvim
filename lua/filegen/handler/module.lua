local custom_template = require("filegen.handler.custom_template")

---@type RegisteredModules
local registered_modules = {}

---@param lsp_names string[]
local function is_lsp_loaded(lsp_names)
  if not lsp_names then
    return false
  end

  for _, client in ipairs(vim.lsp.get_clients()) do
    for _, name in ipairs(lsp_names) do
      if (client.name == name) then
        return true
      end
    end
  end

  return false
end

---@param module RegisteredModule
---@return boolean
local function is_module_loaded(module)
  local lsp_names = module.lsp_name
  local package_name = module.plugin

  if lsp_names and type(lsp_names) == "string" then
    lsp_names = { lsp_names }
  end

  if package_name and not package.loaded[package_name] then
    return false
  end

  ---@diagnostic disable-next-line: param-type-mismatch Is replaced with string[] when only string provided
  if lsp_names and not is_lsp_loaded(lsp_names) then
    return false
  end

  return true
end


local M = {}

---@param name string Name of the module
---@return boolean
function M.is_module_registered(name)
  for _, v in ipairs(registered_modules) do
    if v.name == name then
      return true
    end
  end
  return false
end

---@param module RegisteredModule Module to register
function M.register_module(module)
  for k,v in ipairs(registered_modules) do
    if (v.name == module.name) then
      table.remove(registered_modules, k)
      table.insert(registered_modules, k, module)
      return
    end
  end

  table.insert(registered_modules, module)
end

---@return PickElementTypes?
function M.get_registered_modules()
  ---@type PickElementTypes
  local templates = {}

  templates = vim.tbl_extend("force", templates, custom_template.get_template_types())

  for _, module in pairs(registered_modules) do
    if is_module_loaded(module) then
      table.insert(templates, {
        name = module.name,
        type = "module",
        opts = {
          type = module.type
        }
      })
    end
  end

  if next(templates) == nil then
    vim.notify("No template found to generate.")
    return nil
  end

  return templates
end

---@param element PickElementType
---@param path string
---@param done_callback function
function M.handle_module_call(element, path, done_callback)
  if element.type ~= "module" then
    vim.notify("Non-module type of Element has been given in module call handling", vim.log.levels.ERROR)
  end

  for _, module in pairs(registered_modules) do
    if module.type == element.opts.type then
      if not is_module_loaded(module) then
        vim.notify("Invoked module \"" .. module.name .. "\" is not loaded!", vim.log.levels.ERROR)
        return
      end

      module.handle_module_call(path, done_callback)
      done_callback()
      return
    end
  end

  vim.notify("No valid modules were found for entry: \"" .. element.name .. "\"")
end

return M
