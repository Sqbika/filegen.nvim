---@diagnostic disable: unused-function, unused-local
local picker = require("filegen.handler.picker")
local config = require("filegen.config")
local custom_template = require("filegen.handler.custom_template")

local M = {}

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

  templates = vim.tbl_extend("force", templates, custom_template.get_template_types())

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
    vim.notify(vim.inspect(value))
    if value.type:gmatch("^custom_template_") then
      local ctemplates = custom_template.get_template_files(value)

      vim.notify("files: " .. vim.inspect(ctemplates))
      if ctemplates == nil then
        return
      end

      picker.open_picker(config.config, ctemplates, function (value)
        if not value.type:gmatch("^ct_path:") then
          return
        end

        --TODO Prompt for FileName
        --Create file
        --Copy over Template content
        --Init template placeholder replacement
        vim.notify("Custom Template picked: " .. value.name)
      end)

      return
    end

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
