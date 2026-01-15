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

---@return PickElementType
function M.get_template_types()
  ---@type PickElementTypes
  local templates = {}

  local pt_templates = get_all_custom_templates()
  if next(pt_templates) ~= nil then
    for key, _ in pairs(pt_templates) do
      table.insert(templates, {
        name = key,
        type = "custom_template",
        opts = {
          type = "folder",
          value = key
        }
      })
    end
  end

  return templates
end

---@param type PickElementType
---@return PickElementType?
function M.get_template_files(type)
  local pt_templates = get_all_custom_templates()
  local typeStr = type.opts.value

  if next(pt_templates) == nil then
    return nil
  end

  for key, value in pairs(pt_templates) do
    if key == typeStr then
      --TODO This is stupid
      ---@type PickElementTypes
      local types = {}
      for _, v in ipairs(value) do
        ---@type PickElementType
        table.insert(types, {
          name = v.name,
          type = "custom_template",
          opts = {
            path = v.path
          },
        })
      end
      return types
    end
  end

  vim.notify("No Custom Template type was found for \"" .. type.name .. "\"")
  return nil
end

---@param template PickElementType
---@param target_path string Path where template should be generated
function M.open_template(template, target_path)
  if (template.type ~= "custom_template") or template.opts == nil or template.opts.path == nil then
    vim.notify("Invalid custom template invocation: Not path selection", vim.log.levels.WARN)
    return
  end

  local filename = vim.fn.input("Filename")
  if filename == "" then
    return
  end

  local fullpath = target_path .. "/" .. filename

  local template_path = template.opts.path
  local template_content = vim.fn.readfile(template_path)
  vim.fn.writefile(template_content, fullpath)

  vim.cmd("edit " .. vim.fn.fnameescape(fullpath))
end

return M
