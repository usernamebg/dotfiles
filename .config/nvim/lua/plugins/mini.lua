return {
  {
    'echasnovski/mini.nvim',
    version = false,
    config = function()
      -- Pairs for auto-bracket completion
      require('mini.pairs').setup({
        modes = { insert = true, command = false, terminal = false },
      })

      -- Text manipulation plugins
      require('mini.ai').setup()         -- Enhanced text objects
      require('mini.surround').setup()   -- Surround text objects
    end
  },
}
