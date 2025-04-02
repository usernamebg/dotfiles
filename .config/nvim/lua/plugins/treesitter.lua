return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- config = function()
    --   require('nvim-treesitter.configs').setup({
    --     ensure_installed = { "c", "bash", "rust", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
    --     auto_install = false, -- Set to true if you prefer automatic installation
    --     highlight = {
    --       enable = true,
    --       disable = function(lang, buf)
    --         local max_filesize = 1000 * 1024 -- 1000KB
    --         local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --         if ok and stats and stats.size > max_filesize then
    --           return true -- Disable highlighting for large files
    --         end
    --       end,
    --       additional_vim_regex_highlighting = false,
    --     },
    --     -- Add other modules here if needed, e.g., indent, incremental_selection
    --     -- indent = { enable = true },
    --   })
    -- end,
  },
}
