return {
  {
    -- GO
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)
    end,
    build = function()
      vim.cmd([[silent! GoInstallDeps]])
    end,
    dependencies = {
      "fatih/vim-go",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  -- RUST
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    dependencies = {
      "williamboman/mason.nvim", -- Make sure mason is a dependency
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Only attempt to get CodeLLDB paths if mason is loaded
      local mason_ok, mason_registry = pcall(require, "mason-registry")
      local codelldb_path, liblldb_path
      
      if mason_ok and mason_registry.is_installed("codelldb") then
        local codelldb = mason_registry.get_package("codelldb")
        local extension_path = codelldb:get_install_path() .. "/extension/"
        codelldb_path = extension_path .. "adapter/codelldb"
        liblldb_path = extension_path .. "lldb/lib/liblldb.so"
      end
      
      vim.g.rustaceanvim = {
        -- Server configuration
        server = {
          -- Prevents conflicts with nvim-lspconfig
          standalone = true,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
              inlayHints = {
                enable = true,
              },
              -- Add other rust-analyzer settings here
            },
          },
        },
        -- DAP configuration
        dap = {
          adapter = (codelldb_path and liblldb_path) and {
            type = "server",
            port = "${port}",
            executable = {
              command = codelldb_path,
              args = { "--port", "${port}" },
            },
          } or nil,
        },
        -- Custom key mappings for Rust
        mappings = {
          -- custom keybindings for rust files
        },
      }
      
      -- Set up Rust-specific keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function(event)
          -- Debug bindings with function keys
          vim.keymap.set("n", "<F5>", function()
            vim.cmd("RustLsp debuggables")
          end, { buffer = event.buf, desc = "Debug Rust project" })
          vim.keymap.set("n", "<F9>", function()
            vim.cmd("RustLsp toggleBreakpoint")
          end, { buffer = event.buf, desc = "Toggle breakpoint" })
          vim.keymap.set("n", "<leader>dt", function()
            vim.cmd("RustLsp testables")
          end, { buffer = event.buf, desc = "Rust testables" })
          vim.keymap.set("n", "<leader>rr", function()
            vim.cmd("RustLsp runnables")
          end, { buffer = event.buf, desc = "Rust runnables" })
          vim.keymap.set("n", "<leader>re", function()
            vim.cmd("RustLsp expandMacro")
          end, { buffer = event.buf, desc = "Expand Rust macro" })
        end,
      })
    end,
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },
  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup({
        completion = {
          cmp = {
            enable = true,
          },
        },
      })
      require("cmp").setup.buffer({
        sources = {
          { name = "crates" },
        },
      })
    end,
  },
}
