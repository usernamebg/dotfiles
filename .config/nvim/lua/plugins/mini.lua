return {
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      -- Basic settings and mappings
      require('mini.basics').setup({
        options = {
          basic = true,
          extra_ui = true,
          win_borders = 'default',
        },
        mappings = {
          basic = true,
          option_toggle_prefix = [[\]],
          windows = true,
          move_with_alt = true,
        },
        autocommands = {
          basic = true,
          relnum_in_visual_mode = true,
        },
      })

      -- Enhanced statusline (you already had this)
      require('mini.statusline').setup({ 
        use_icons = true,
        set_vim_settings = true,
      })

      -- File explorer (replaces oil.nvim)
      require('mini.files').setup({
        windows = {
          preview = true,
          width_focus = 30,
          width_preview = 40,
        },
        mappings = {
          go_in = 'l',
          go_in_plus = 'L',
          go_out = 'h',
          go_out_plus = 'H',
        },
      })

      -- Pairs for auto-bracket completion
      require('mini.pairs').setup({
        modes = { insert = true, command = false, terminal = false },
      })

      -- Text manipulation plugins
      require('mini.ai').setup()         -- Enhanced text objects
      require('mini.surround').setup()   -- Surround text objects
      require('mini.comment').setup()    -- Comment lines/blocks
      require('mini.align').setup()      -- Text alignment
      require('mini.indentscope').setup() -- Visualize and operate on indentation
      require('mini.move').setup({       -- Move lines and blocks
        mappings = {
          -- Move visual selection in Visual mode
          left = '<S-h>',
          right = '<S-l>',
          down = '<S-j>',
          up = '<S-k>',
          -- Move current line in Normal mode
          line_left = '<S-h>',
          line_right = '<S-l>',
          line_down = '<S-j>',
          line_up = '<S-k>',
        },
      })
      
      -- Buffer management
      require('mini.bufremove').setup()  -- Better buffer closing
      
      -- Git integration
      require('mini.diff').setup()       -- Show Git diff in sign column

      -- Navigation and UI
      require('mini.jump').setup()       -- Enhanced f/t motions
      require('mini.jump2d').setup()     -- 2D jumping (like EasyMotion/Hop)
      require('mini.clue').setup({       -- Provide keybinding help (replaces which-key)
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },
          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },
          -- Window commands
          { mode = 'n', keys = '<C-w>' },
          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },
          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },
          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },
          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },
        clues = {
          -- Enhance this with your custom key mappings
          { mode = 'n', keys = '<Leader>f', desc = '+Find' },
          { mode = 'n', keys = '<Leader>d', desc = '+Debug' },
          { mode = 'n', keys = '<Leader>g', desc = '+Git' },
        },
      })
      -- Animations for a more modern feel
      require('mini.animate').setup({
        cursor = { enable = true },
        scroll = { enable = true },
        resize = { enable = true },
        open = { enable = true },
        close = { enable = true },
      })
      -- Dashboard (replaces dashboard-nvim)
      require('mini.starter').setup({
        header = 'Welcome to Neovim',
        footer = '',
        items = {
          { section = 'Files', item = { 'f', 'Find file', 'Telescope find_files' } },
          { section = 'Files', item = { 'r', 'Recent files', 'Telescope oldfiles' } },
          { section = 'Files', item = { 'n', 'New file', 'enew' } },
          { section = 'Config', item = { 'c', 'Config', 'e $MYVIMRC' } },
          { section = 'Quit', item = { 'q', 'Quit', 'qa' } },
        },
      })
      -- Additional utilities
      require('mini.trailspace').setup() -- Show and trim trailing whitespace
      require('mini.cursorword').setup() -- Highlight word under cursor
      -- Key mappings for mini modules
      vim.keymap.set("n", "<leader>e", ":lua MiniFiles.open()<CR>", { desc = "Open file explorer" })
      vim.keymap.set("n", "<leader>u", ":lua MiniDiff.toggle_signs()<CR>", { desc = "Toggle diff markers" })
      vim.keymap.set("n", "<leader>fw", ":lua MiniTrailspace.trim()<CR>", { desc = "Trim whitespace" })
      vim.keymap.set('n', '<leader>bd', ":lua MiniBufremove.delete()<CR>", { desc = "Delete buffer" })
      vim.keymap.set('n', '<leader>bw', ":lua MiniBufremove.wipeout()<CR>", { desc = "Wipeout buffer" })
    end
  },
}
