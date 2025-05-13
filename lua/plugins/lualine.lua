return {
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
      },
      sections = {
        lualine_c = {
          {
            'filename',
            path = 1,
          }
        },
      }
    },
  },
}
