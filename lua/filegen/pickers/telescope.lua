local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local M = {}

--TODO Refactor into PickerOptions
---@param rows PickElementTypes 
---@param callback SelectionCallback
local function open_picker(rows, callback)
  local opts = require("telescope.themes").get_dropdown {
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        callback(action_state.get_selected_entry().value)
      end)
      return true
    end
  }

  if next(rows) == nil then
    vim.notify("No templates found.")
    return nil
  end

  local picker = pickers.new(opts, {
    prompt_title = "Select template Category",
    finder = finders.new_table({
      results = rows,
      ---@param entry PickElementType
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name,
          ordinal = entry.name
        }
      end,
    }),
    sorted = conf.generic_sorter(opts)
  })

  picker:find()
end

function M.register()
  local picker = require("filegen.handler.picker")

  if not picker.is_picker_registered("telescope") then
    picker.register_picker({
      name = "telescope",
      fn_open = open_picker
    })
  end
end

return M
