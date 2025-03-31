return {
  {
    'nvim-telescope/telescope.nvim', 
    tag = '0.1.8',
    dependencies = { 
      'nvim-lua/plenary.nvim', 
      "BurntSushi/ripgrep", 
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, 
      "sharkdp/fd", 
      "nvim-treesitter/nvim-treesitter"
    },
    config = function()
      require("telescope").setup({
          defaults = {
            file_ignore_patterns = {
              "%.git/",
              "node_modules/",
              "__pycache__/",
              "*-lock",
              "lazyvim.json",
              "**lock",
              "%.cache",
              "%.o",
              "%.a",
              "%.out",
              "%.class",
              "%.pdf",
              "%.mkv",
              "%.mp4",
              "%.zip",
            },
        },
        pickers = {
          find_files = {
            theme = "ivy",
            layout_config = {
              height = 0.85,
            },
          },
          diagnostics = {
            theme = "dropdown",
          },
          command_history = {
            theme = "cursor",
          },
        },
        extensions = {
          fzf = {},
        }
      })

      require('telescope').load_extension('fzf')

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
      vim.keymap.set('n', '<leader>ft', builtin.treesitter, { desc = 'Telescope Treesitter' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope LSP diagnostics' })
      vim.keymap.set('n', '<leader>fc', builtin.command_history, { desc = 'Telescope command history' })

      require "utils.multigrep".setup()
    end
  }
}
