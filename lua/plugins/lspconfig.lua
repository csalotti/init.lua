return {
    {
        "neovim/nvim-lspconfig",
        opts = function()
            local lua_ls_on_init = function(client)
                local path = vim.tbl_get(client, "workspace_folders", 1, "name")
                if not path then
                    return
                end
                -- override the lua-language-server settings for Neovim config
                client.settings = vim.tbl_deep_extend('force', client.settings, {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME
                            }
                        }
                    }
                })
            end

            vim.diagnostic.config({ virtual_lines = true })

            local servers = {
                lua_ls = {
                    on_init = lua_ls_on_init
                },
                terraformls = {},
                gh_actions_ls = {},
                basedpyright = {
                    settings = {
                        basedpyright = {
                            -- Using Ruff's import organizer
                            disableOrganizeImports = true,
                            analysis = {
                                typeCheckingMode = "basic"
                            },
                        },
                    },
                },
                ruff = {
                    on_attach = function(client, _)
                        -- Disable hover in favor of Pyright
                        client.server_capabilities.hoverProvider = false
                    end,
                },
                clangd = {},
                rust_analyzer = {},
                fish_lsp = {},
            }
            return servers
        end,
        config = function(_, servers)
            for server, opts in pairs(servers) do
                require('lspconfig')[server].setup(opts)
            end
        end,
    }
}
