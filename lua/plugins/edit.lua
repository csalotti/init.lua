-- Config related to edition such as tab, indentation and additions while coding
return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },

  'echasnovski/mini.pairs',

}
