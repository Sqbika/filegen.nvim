---@meta

---@class TemplateType
---@field name string Name of the specified template
---@field type string Inner type name for identification

---@alias TemplateTypes TemplateType[]

---@alias SelectionCallback fun(template: TemplateType)
---@alias PickerFn fun(rows: TemplateTypes, callback: SelectionCallback)

---@class RegisteredPicker
---@field name string Picker name
---@field fn_open PickerFn function to open picker

---@alias RegisteredPickers RegisteredPicker[]
