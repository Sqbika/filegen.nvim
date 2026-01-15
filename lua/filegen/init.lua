---@diagnostic disable: unused-function, unused-local
local picker = require("filegen.handler.picker")
local module = require("filegen.handler.module")
local config= require("filegen.config")
local custom_template = require("filegen.handler.custom_template")

local M = {}

---@param path string
---@param done_callback function
function M.generate_from_template(path, done_callback)
  local templates = module.get_registered_modules()

  if templates == nil then
    return
  end

  picker.open_picker(config.config, templates, function (value)
    --vim.notify(vim.inspect(value))
    if value.type == "custom_template" then
      local ctemplates = custom_template.get_template_files(value)

      if ctemplates == nil then
        return
      end

      picker.open_picker(config.config, ctemplates, function (value)
        custom_template.open_template(value, path)
        done_callback()
        --TODO Init template placeholder replacement
      end)

      return
    elseif value.type == "module" then
      module.handle_module_call(value, path, done_callback)
    else
      vim.notify("Unknown element type \"" .. value.type .. "\"")
    end
  end)
end

---@param opts FilegenConfig
function M.setup(opts)
  config.setup_config(opts)

  local configObj = config.config

  if configObj.enable_builtin then
    if configObj.enable_builtin == true or configObj.enable_builtin.pickers == true then
      require("filegen.pickers.telescope").register()
    end

    if configObj.enable_builtin == true or configObj.enable_builtin.modules == true then
      require("filegen.modules.csharp_easy-dotnet").register()
    end
  end

  if type(configObj.picker_definitions) == "table" and next(configObj.picker_definitions) ~= nil then
      for _, picker_def in pairs(configObj.picker_definitions) do
        if not picker.is_picker_registered(picker_def.name) then
          picker.register_picker(picker_def)
        end
      end
  end

  if type(configObj.module_definitions) == "table" and next(configObj.module_definitions) ~= nil then
      for _, module_def in pairs(configObj.module_definitions) do
        if not module.is_module_registered(module_def.name) then
          module.register_module(module_def)
        end
      end
  end
end

return M
