return {
    "neovim/nvim-lspconfig",
    lazy = true,
    init = function()
        local lspConfigPath = require("lazy.core.config").options.root .. "/nvim-lspconfig"
        vim.opt.runtimepath:prepend(lspConfigPath)
        vim.lsp.enable({
            "lua_ls",
            "terraformls",
            "gh_actions_ls",
            "basedpyright",
            "ruff",
            "clangd",
            "rust_analyzer",
            "fish_lsp"
        })
    end,
}
