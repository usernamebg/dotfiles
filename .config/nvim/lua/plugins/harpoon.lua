return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },

    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        vim.keymap.set("n", "<C-a>", function()
            harpoon:list():add()
        end, { desc = "Harpoon: Add current file" }) -- Added desc

        vim.keymap.set("n", "<C-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, { desc = "Harpoon: Toggle Quick Menu" }) -- Added desc

        for i = 1, 10 do
            vim.keymap.set("n", "<C-" .. i .. ">", function()
                harpoon:list():select(i)
            -- Concatenate description string correctly
            end, { desc = "Harpoon: Go to mark " .. i }) -- Added desc with correct concatenation
        end
    end,
}
