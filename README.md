# filegen.nvim
A file generator plugin that uses user defined .template and LSP based generation. Other plugins support are also WIP

# Why?
* I'm migrating from Jetbrains
* Generate project/context accurate files like in your ex-IDE
    * Angular? use `ng-generate` nvim plugin or native cli generation
    * Java? create the usual boilerplate or even more! or less? your choice
    * Not found? Create your own in a .template or define a generation strategy

# Roadmap (unordered)
* [ ] Generate simple files from .template
* [ ] Implement LSP based modules
* [ ] Implement Custom module registry
* [ ] Implement .template file templating
    * Upon file creation, you are prompted to replace `{PLACEHOLDER}` entries.
* [ ] Implement more file pickers
* [ ] Create commands for fast creation without picker
