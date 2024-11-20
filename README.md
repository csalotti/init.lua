# NVIM config

Custom nvim configuration, based on [kickstarter.nvim](https://github.com/dam9000/kickstart-modular.nvim)

## Structure

```bash
.
├── init.lua      # (DO NOT CHANGE) entry point
└── lua
    ├── core      # Core functionnalitires : maps, lazy and options
    └── plugins   # Plugins or group of plugins config
```

## Plugins

Plugins are installed and configured in their dedicasted file. Muliple plugins can be installed in the same file (e.g. appeareance for themes and other options)

### LSP 

LSP is handled with Mason and LSP config. All configuration is currently done on mason file use default config.
