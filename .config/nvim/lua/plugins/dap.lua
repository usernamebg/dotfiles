return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},

	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.after.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.after.event_exited.dapui_config = function()
			dapui.close()
		end

		-- Keybindings for Debug Adapter Protocol (DAP)
		vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
		vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Continue debugging/start session" })

		vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "Open Debugger REPL" })
		vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "Step into function/statement" })
		vim.keymap.set("n", "<Leader>do", dap.step_over, { desc = "Step over function/statement" })
		vim.keymap.set("n", "<Leader>du", dap.step_out, { desc = "Step out of function/scope" })
		vim.keymap.set("n", "<Leader>dt", dap.terminate, { desc = "Terminate debugging session" })

		dap.set_log_level("TRACE")

		-- adapters /repo/git_stuff
		dap.adapters.firefox = {
			type = "executable",
			command = "node",
			os.getenv("HOME") .. "/repo/git_stuff/vscode-firefox-debug/dist/adapter.bundle.js",
		}

		dap.configurations.typescript = {
			{
				name = "Debug with Firefox",
				type = "firefox",
				request = "launch",
				reAttach = true,
				url = "http://localhost:3000",
				webRoot = "${workspaceFolder}",
				firefoxExecutable = "/usr/bin/firefox",
			},
		}
	end,
}
