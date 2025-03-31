return {
	{
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    require('dashboard').setup {
      -- config
    }
  end,
  dependencies = { {'nvim-tree/nvim-web-devicons'}}
},

{
   'nvim-lualine/lualine.nvim',
   dependencies = { 'nvim-tree/nvim-web-devicons' },
   config = function()
     require('lualine').setup {
       options = {
         -- ... your other options ...
         icons_enabled = true,
         theme = 'ayu_dark',
         component_separators = { left = '', right = ''},
         section_separators = { left = '', right = ''},
         disabled_filetypes = { statusline = {}, winbar = {} },
         ignore_focus = {},
         always_divide_middle = true,
         globalstatus = false,
         refresh = { statusline = 100, tabline = 100, winbar = 100 }
       },
       -- == STATUSLINE (Bottom Bar) ==
       -- Kept empty as per previous step (hidden via vim.opt.laststatus = 0)
       sections = {
         lualine_a = {}, lualine_b = {}, lualine_c = {},
         lualine_x = {}, lualine_y = {}, lualine_z = {}
       },
       inactive_sections = {
         lualine_a = {}, lualine_b = {}, lualine_c = {},
         lualine_x = {}, lualine_y = {}, lualine_z = {}
       },
       -- == TABLINE ==
       tabline = {
         -- ... your tabline config ...
       },
       -- == WINBAR (Top Bar per Window) ==
       winbar = {
         -- 'mode' on the far left
         lualine_a = {'mode'},
         -- 'diagnostics' and 'progress' next to it
         lualine_b = {'diagnostics', 'progress'},
         -- Ensure other sections are empty
         lualine_c = {},
         lualine_x = {},
         lualine_y = {},
         lualine_z = {}
       },
       inactive_winbar = {
        -- Kept empty as previously configured
         lualine_a = {}, lualine_b = {}, lualine_c = {},
         lualine_x = {}, lualine_y = {}, lualine_z = {}
         -- You could mirror the active winbar if preferred:
         -- lualine_a = {'mode'},
         -- lualine_b = {'diagnostics', 'progress'},
         -- lualine_c = {}, lualine_x = {}, lualine_y = {}, lualine_z = {}
       },
       extensions = {} -- Keep any extensions
     }
   end
 },

 -- Reminder: Ensure you have this line in your main init.lua to hide the bottom statusline
 -- vim.opt.laststatus = 0

	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		opts = function(_, opts)
			-- Initialize routes if it doesn't exist
			opts.routes = opts.routes or {}
			
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "no information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})
			opts.commands = {
				all = {
					-- options for the message history that you get with `:noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}
			-- Initialize presets if it doesn't exist
			opts.presets = opts.presets or {}
			opts.presets.lsp_doc_border = true
		end,
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
			background_colour = "#000000",
			render = "wrapped-compact",
		},
	},
}
