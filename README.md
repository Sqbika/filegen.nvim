# filegen.nvim
A file generator plugin that uses user defined .template and LSP based generation. Other plugins support are also WIP

# Why?
* I'm migrating from Jetbrains
* Generate project/context accurate files like in your ex-IDE
    * Angular? use `ng-generate` nvim plugin or native cli generation
    * Java? create the usual boilerplate or even more! or less? your choice
    * Not found? Create your own in a .template or define a generation strategy

# Config
Now custom configuration is available:

## Using lazy.nvim
```lua
{
    "sqbika/filegen.nvim",
    opts = {
      enable_builtin = { --Can be false / true instead table to turn on (default) or off builtin definitions
        pickers = true,
        modules = true
      },
      picker = "auto", --Name of the picker to use, "auto" uses first available one
      picker_definitions = {
        {
          name = "Auto Select First",
          fn_open = function(rows, callback)
            --rows contain all the all available options
            --callback is a function with a single parameter from the callback
            callback(next(rows))
          end
        }
      }
      module_definitions = {
        {
          name = "Test Module",
          type = "test_module",
          handle_module_call = function (path, done_callback)
            vim.notify("Test Module works, path: ".. path)
            done_callback()
          end
        }
      }
    }
}
```

# Roadmap (unordered)
* [x] Generate simple files from .template
  * [x] Source .template files from `$(NVIM_CONFIG)/templates`
  * [ ] Source .template files from `$PROJECT_ROOT/.templates` ?
* [x] Implement LSP based modules
* [x] Implement Custom module registry
* [ ] Implement .template file templating
    * Upon file creation, you are prompted to replace `{PLACEHOLDER}` entries.
* [ ] Implement more file pickers
* [ ] Create commands for fast creation without picker
