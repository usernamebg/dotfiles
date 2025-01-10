return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	requires = { "nvim-lua/plenary.nvim" },

	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		-- Set keymaps for adding to and toggling the quick menu
		vim.keymap.set("n", "<C-a>", function()
			harpoon:list():add()
		end)
		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		-- Use a for loop to map control key for selecting items 1 through 10
		for i = 1, 10 do
			vim.keymap.set("n", "<C-" .. i .. ">", function()
				harpoon:list():select(i)
			end)
		end
	end,
}
