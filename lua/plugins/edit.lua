-- Config related to edition such as tab, indentation
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

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- "Marks" to navigate efficiently
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      -- REQUIRED
      harpoon:setup({})
      -- REQUIRED
      -- basic telescope configuration
      vim.keymap.set("n", "<leader>kl", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = "Open harpoon window" })
      vim.keymap.set("n", "<leader>ka", function() harpoon:list():add() end,
        { desc = "Add to harpoon list" })
      for i = 0, 9 do
        vim.keymap.set("n", string.format("<leader>k%s", i), function() harpoon:list():select(i) end,
          { desc = string.format("Go to binding %s", i) })
      end
      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set("n", "<leader>kp", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<leader>kn", function() harpoon:list():next() end)
    end
  },
  {
    "letieu/harpoon-lualine",
    dependencies = {
      {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
      }
    },
  }
}
