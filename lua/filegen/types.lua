---@meta

---@class PickElementType
---@field name string Name of the specified template
---@field type string Inner type name for identification
---@field opts any Custom configuration for picker / module

---@alias PickElementTypes PickElementType[]

---@alias SelectionCallback fun(template: PickElementType)
---@alias PickerFn fun(rows: PickElementTypes, callback: SelectionCallback)

---@class PickerOptions
---@field callback PickerFn
---@field title? string

---@class RegisteredPicker
---@field name string Picker name
---@field fn_open PickerFn function to open picker

---@alias RegisteredPickers RegisteredPicker[]

---@class CustomTemplatePath
---@field name string Template name
---@field path string Path to template file

---@alias CustomTemplates table<string, CustomTemplatePath[]>

--#region Modules
---@alias ModuleCallFunc fun(path: string, done_callback: function)

---@class RegisteredModule
---@field name string Module display name
---@field type string Internal module type name
---@field lsp_name? string | string[] LSP name(s) that should be loaded (OR)
---@field plugin? string Plugin name that should be loaded
---@field handle_module_call ModuleCallFunc

---@alias RegisteredModules RegisteredModule[]
--#endregion
