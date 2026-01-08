local M = {}


---@return CustomTemplates
local function get_all_custom_templates()
  local base_path = vim.fn.stdpath("config") .. "/templates"
  local templates = {}

  for template_type, outer_type in vim.fs.dir(base_path) do
    if outer_type == "directory" then
      local type_template = {}
      --TODO: Add recursive search here
      for filepath, type in vim.fs.dir(base_path .. "/" .. template_type) do
        if type == "file" then
          table.insert(type_template, {
            name = filepath:gsub("%.template$", ""),
            path = base_path .. "/" .. template_type .. "/" .. filepath
          })
        end
      end
      if next(type_template) ~= nil then
        templates[template_type] = type_template
      end
    end
  end
  return templates
end

---@return TemplateTypes
function M.get_template_types()
  ---@type TemplateTypes
  local templates = {}

  local pt_templates = get_all_custom_templates()
  if next(pt_templates) ~= nil then
    for key, _ in pairs(pt_templates) do
      table.insert(templates, {
        name = key,
        type = "custom_template_" .. key
      })
    end
  end

  return templates
end

---@param type TemplateType
---@return TemplateTypes?
function M.get_template_files(type)
  local pt_templates = get_all_custom_templates()
  local typeStr = type.type:gsub("^custom_template_", "")

  if next(pt_templates) == nil then
    return nil
  end

  for key, value in pairs(pt_templates) do
    if key == typeStr then
      --TODO This is stupid
      ---@type TemplateTypes
      local types = {}
      for _,v in ipairs(value) do
        ---@type TemplateType
        table.insert(types, {
          name = v.name,
          type = "ct_path:"
        })
      end
      return types
    end
  end

  vim.notify("No Custom Template type was found for \"" .. type.name .. "\"")
  return nil
end

return M

