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
		-- Core debugging controls
		vim.keymap.set("n", "<F1>", dap.continue, { desc = "Continue debugging/start session" })
		vim.keymap.set("n", "<F2>", dap.terminate, { desc = "Terminate debugging session" })

		-- Stepping controls
		vim.keymap.set("n", "<F3>", dap.step_over, { desc = "Step over function/statement" })
		vim.keymap.set("n", "<F4>", dap.step_into, { desc = "Step into function/statement" })
		vim.keymap.set("n", "<F5>", dap.step_out, { desc = "Step out of function/scope" })

		-- Breakpoints and REPL
		vim.keymap.set("n", "<F6>", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
		vim.keymap.set("n", "<F7>", dap.repl.open, { desc = "Open Debugger REPL" })

		vim.keymap.set("n", "<leader>dt", "<cmd> lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })
		-- Keeping old one for now
		vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
		vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Continue debugging/start session" })

		vim.keymap.set("n", "<Leader>dr", dap.repl.open, { desc = "Open Debugger REPL" })
		vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "Step into function/statement" })
		vim.keymap.set("n", "<Leader>do", dap.step_over, { desc = "Step over function/statement" })
		vim.keymap.set("n", "<Leader>du", dap.step_out, { desc = "Step out of function/scope" })
		vim.keymap.set("n", "<Leader>dt", dap.terminate, { desc = "Terminate debugging session" })

		dap.set_log_level("TRACE")
	end,
}
