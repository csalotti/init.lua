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
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    pcall(function() vim.cmd [[%s/\s\+$//e]] end)
    vim.fn.setpos(".", save_cursor)
  end,
})

-- lsp
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspAttach", { clear = false }),
  ---comment
  ---@param ev vim.api.keyset.create_autocmd.callback_args
  callback = function(ev)
    -- keymaps
    vim.keymap.set('n', "<leader>rn", vim.lsp.buf.rename, { desc = '[R]e[n]ame', buffer = ev.buf })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction', buffer = ev.buf })
    vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions,
      { desc = '[G]oto [D]efinition', buffer = ev.buf })
    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references,
      { desc = '[G]oto [R]eferences', buffer = ev.buf })
    vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations,
      { desc = '[G]oto [I]mplementation', buffer = ev.buf })
    vim.keymap.set('n', '<leader>D', require('telescope.builtin').lsp_type_definitions,
      { desc = 'Type [D]efinition', buffer = ev.buf })
    vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols,
      { desc = '[D]ocument [S]ymbols', buffer = ev.buf })
    vim.keymap.set('n', '<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
      { desc = '[W]orkspace [S]ymbols', buffer = ev.buf })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation', buffer = ev.buf })
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Signature Documentation', buffer = ev.buf })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration', buffer = ev.buf })

    -- formatter
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = ev.buf,
      callback = function()
        vim.lsp.buf.format { async = false, id = ev.data.client_id }
      end,
    })
  end,
})

-- commentstring
vim.api.nvim_create_autocmd("FileType", {
  pattern = "terraform",
  callback = function()
    vim.bo.commentstring = "# %s"
  end
})
