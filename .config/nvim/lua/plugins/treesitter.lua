return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "c", "python", "bash", "rust", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
        auto_install = false,

        sync_install = false,
        ignore_install = {},
        modules = {},

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<Enter>", -- set to `false` to disable one of the mappings
            node_incremental = "<Enter>",
            scope_incremental = false,
            node_decremental = "<Backspace>",
          },
        },
      })
    end,
  },
}
