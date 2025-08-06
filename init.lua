-- Global
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

--Bootstrap lazy.nvim
local lazypath       = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	-- ui config
	ui = { border = "double", size = { width = 0.8, height = 0.8 } },
	checker = { enabled = true, notify = false },
	change_detection = { notify = false },
	spec = {
		{
			"neovim/nvim-lspconfig",
			lazy = false,
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
			end
		},
		{ "nvim-treesitter/nvim-treesitter", branch = 'main', lazy = false, build = ":TSUpdate" },
		{
			'stevearc/oil.nvim',
			keys = { { "-", "<CMD>Oil<CR>", desc = "Open parent directory" } },
			opts = { view_options = { show_hidden = true, }, },
		},
		{
			"ibhagwan/fzf-lua",
			lazy = false,
			keys = {
				{ "<leader>sf",      "<cmd>FzfLua files<cr>",     desc = "Fzf search files" },
				{ "<leader>sg",      "<cmd>FzfLua live_grep<cr>", desc = "Fzf search files" },
				{ "<leader><space>", "<cmd>FzfLua buffers<cr>",   desc = "Fzf search files" },
			},
			opts = {
				grep = { hidden = true },
			}
		},
		"sindrets/diffview.nvim",
		"vague2k/vague.nvim",
	}
})

-- Visaul settings
vim.wo.number         = true
vim.wo.relativenumber = true
vim.wo.signcolumn     = 'yes'
vim.opt.completeopt   = 'menuone,noselect,popup'
vim.o.hlsearch        = false
vim.o.termguicolors   = true
vim.o.cursorline      = true
vim.o.scrolloff       = 10
vim.o.sidescrolloff   = 10

-- Indentation
vim.o.sts             = 4
vim.o.shiftwidth      = 4
vim.o.smartindent     = true
vim.o.autoindent      = true

-- File handling
vim.o.swapfile        = false
vim.o.backup          = false
vim.o.writebackup     = false

-- Behavior
vim.o.clipboard       = 'unnamedplus'
vim.o.ignorecase      = true
vim.o.smartcase       = true


-- Colorscheme
-- vim.cmd.colorscheme 'vague'

-- Diagnostic
vim.diagnostic.config({
	virtual_lines = { current_line = true },
	severity_sort = true
})

-- Keymaps
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setqflist)
-- Indent and reselect
vim.keymap.set('v', '>', '>gv', { desc = "Indent right and reselet" })
vim.keymap.set('v', '<', '<gv', { desc = "Indent left and reselet" })
-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })
-- Splits
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split Vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split Horizontally" })
-- Move blocks
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move Selection up" })
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move Selection down" })

-- Commands
-- lsp
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspAttach", { clear = false }),
	---@param args vim.api.keyset.create_autocmd.callback_args
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

		-- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, {
				autotrigger = true,
				convert = function(item)
					return { abbr = item.label:gsub('%b()', '') }
				end,
			})
		end
		-- Auto-format ("lint") on save.
		-- Usually not needed if server supports "textDocument/willSaveWaitUntil".
		if not client:supports_method('textDocument/willSaveWaitUntil')
			and client:supports_method('textDocument/formatting') then
			vim.api.nvim_create_autocmd('BufWritePre', {
				group = vim.api.nvim_create_augroup('UserLspAttach', { clear = false }),
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
		if client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true)
		end

		vim.keymap.set('i', '<c-space>', function() vim.lsp.completion.get() end,
			{ desc = "Trigger lsp completion once in the current buffer" })
		-- Map <Tab> and <S-Tab> to an expression (|:map-<expr>|):
		vim.keymap.set('i', '<Tab>', function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end,
			{ expr = true })
		vim.keymap.set('i', '<S-Tab>', function()
			return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
		end, { expr = true })
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
			{ desc = 'Jump to the definition of the symbol under the cursor' })
	end,
})
-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})
-- Remove trailing whitespaces
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*" },
	callback = function()
		local save_cursor = vim.fn.getpos(".")
		pcall(function() vim.cmd [[%s/\s\+$//e]] end)
		vim.fn.setpos(".", save_cursor)
	end,
})
