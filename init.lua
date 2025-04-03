-- Options must be imported before lazy
require("config.options")
require("config.lazy")
require("config.abbrev")
require("config.keymaps")
require("config.autocmds")
require("config.commands")

-- NVIM theme
vim.cmd.colorscheme 'rose-pine'
