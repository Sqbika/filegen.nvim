---@diagnostic disable: unused-function, unused-local
local picker = require("filegen.handler.picker")
local config = require("filegen.config")

local M = {}

---@return table
local function get_all_custom_templates()
  local base_path = vim.fn.stdpath("config") .. "/templates"
  local templates = {}

  for template_type, outer_type in vim.fs.dir(base_path) do
    if outer_type == "directory" then
      local type_template = {}
      --TODO: Add recursive search here
      for filepath, type in vim.fs.dir(base_path .. "/" .. template_type) do
        if type == "file" then
          type_template = vim.tbl_deep_extend("force", type_template, {
            name = filepath:gsub("%.template$", ""),
            path = base_path .. "/" .. template_type .. "/" .. filepath
          })
        end
      end
      templates[template_type] = type_template
    end
  end
  return templates
end

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

---@param package_name string | nil
---@param lsp_names string | string[] | nil
---@return boolean
local function is_module_loaded(package_name, lsp_names)
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

---@param state table
function M.generate_from_template(state)
  local node = state.tree:get_node()
  if not node or node.type == "message" then
    return
  end

  local templates = {}

  local function add_template(name, type)
    table.insert(templates, {
      name = name,
      type = type
    })
  end

  local pt_templates = get_all_custom_templates()
  if next(pt_templates) ~= nil then
    for key, value in pairs(pt_templates) do
--      vim.notify("Key: ".. key .. "\n Value: " .. vim.inspect(value))
      add_template(key, "custom_template_" .. key)
    end
  else
    vim.notify("No Custom Templates found")
  end

  if is_module_loaded(nil, { "kotlin_language_server", "kotlin_lsp" }) then
    add_template("Kotlin", "kt")
  end

  if is_module_loaded("easy-dotnet", { 'easy_dotnet', 'csharp_ls', 'ominsharp', 'ominsharp-mono' }) then
    add_template("C#", "cs")
  end

  if is_module_loaded("ng-generate", nil) then
    add_template("Angular", "angular")
  end

  if next(templates) == nil then
    vim.notify("No template found to generate.")
    return
  end

  picker.open_picker(config.config, templates, function (value)
    vim.notify("callback")
    vim.notify(vim.inspect(value))
  end)
end

---@param opts FilegenConfig
function M.setup(opts)
  config.setup_config(opts)

  --#region Builtin Pickers
  require("filegen.pickers.telescope").register()
  --
end

return M
