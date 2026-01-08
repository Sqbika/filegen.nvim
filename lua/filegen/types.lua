---@meta

---@class TemplateType
---@field name string Name of the specified template
---@field type string Inner type name for identification

---@alias TemplateTypes TemplateType[]

---@alias SelectionCallback fun(template: TemplateType)
---@alias PickerFn fun(rows: TemplateTypes, callback: SelectionCallback)

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
