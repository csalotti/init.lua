-- See `:help telescope` and `:help telescope.setup()`
return {
  {
    -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    keys = {
      { '<leader>?',       require('telescope.builtin').oldfiles, desc = '[?] Find recently opened files' },
      { '<leader><space>', require('telescope.builtin').buffers,  desc = '[ ] Find existing buffers' },
      {
        '<leader>/',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes')
            .get_dropdown({ winblend = 50, previewer = true }))
        end,
        desc = '[/] Fuzzily search in current buffer'
      },
      {
        '<leader>s/',
        function()
          require('telescope.builtin').live_grep({
            grep_open_files = true,
            prompt_title =
            'Live Grep in Open Files'
          })
        end,
        desc = '[S]earch [/] in Open Files'
      },
      { '<leader>ss', require('telescope.builtin').builtin,     desc = '[S]earch [S]elect Telescope' },
      { '<leader>gf', require('telescope.builtin').git_files,   desc = 'Search [G]it [F]iles' },
      { '<leader>sf', require('telescope.builtin').find_files,  desc = '[S]earch [F]iles' },
      { '<leader>sh', require('telescope.builtin').help_tags,   desc = '[S]earch [H]elp' },
      { '<leader>sw', require('telescope.builtin').grep_string, desc = '[S]earch current [W]ord' },
      { '<leader>sg', require('telescope.builtin').live_grep,   desc = '[S]earch by [G]rep' },
      { '<leader>sG', ':LiveGrepGitRoot<cr>',                   desc = '[S]earch by [G]rep on Git Root' },
      { '<leader>sd', require('telescope.builtin').diagnostics, desc = '[S]earch [D]iagnostics' },
      { '<leader>sr', require('telescope.builtin').resume,      desc = '[S]earch [R]esume' },
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
          },
        },
      },
    },
    config = function()
      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')

      -- Telescope live_grep in git root
      -- Function to find the git root directory based on the current buffer's path
      local function find_git_root()
        -- Use the current buffer's path as the starting point for the git search
        local current_file = vim.api.nvim_buf_get_name(0)
        local current_dir
        local cwd = vim.fn.getcwd()
        -- If the buffer is not associated with a file, return nil
        if current_file == '' then
          current_dir = cwd
        else
          -- Extract the directory from the current file's path
          current_dir = vim.fn.fnamemodify(current_file, ':h')
        end

        -- Find the Git root directory from the current file's path
        local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')
            [1]
        if vim.v.shell_error ~= 0 then
          print 'Not a git repository. Searching on current working directory'
          return cwd
        end
        return git_root
      end

      -- Custom live_grep function to search in git root
      local function live_grep_git_root()
        local git_root = find_git_root()
        if git_root then
          require('telescope.builtin').live_grep {
            search_dirs = { git_root },
          }
        end
      end

      vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})
    end
  },

  {
    'stevearc/oil.nvim',
    keys = {
      { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
    },
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
  },

  -- "Marks" to navigate efficiently
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
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
}
