return {
  "folke/tokyonight.nvim",
  name = "tokyonight",
  lazy = false, 
  priority = 1000,
  config = function()
    local black = "#000000" 
    local white = "#FFFFFF"

    require("tokyonight").setup({
      style = "night",
      transparent = false,

      on_colors = function(colors)
        colors.bg = black         -- Main editor background
        colors.bg_dark = black    -- Darker background variant (often used in sidebars/floats)
        colors.bg_float = black   -- Explicit float background
        colors.bg_popup = black   -- Often same as bg_float
        colors.bg_sidebar = black -- Explicit sidebar background 

        colors.bg_statusline = white
      end,
    })

    vim.cmd("colorscheme tokyonight")

  end,
}
