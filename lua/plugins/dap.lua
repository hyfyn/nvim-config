-- Debug adapters installed through Mason
local adapters = { "delve", "js-debug-adapter" }

local function ensure_adapters()
	local registry = require("mason-registry")
	registry.refresh(function()
		for _, name in ipairs(adapters) do
			local ok, pkg = pcall(registry.get_package, name)
			if ok and not pkg:is_installed() then
				pkg:install()
			end
		end
	end)
end

local function setup_js(dap)
	local pwa_node = {
		type = "server",
		host = "localhost",
		port = "${port}",
		executable = {
			command = vim.fn.stdpath("data") .. "/mason/bin/js-debug-adapter",
			args = { "${port}" },
		},
	}
	dap.adapters["pwa-node"] = pwa_node
	-- VS Code launch.json files use `"type": "node"`; js-debug only knows pwa-node
	dap.adapters["node"] = function(callback, config)
		config.type = "pwa-node"
		callback(pwa_node)
	end

	local configs = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch current file",
			program = "${file}",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach to process",
			processId = function()
				return require("dap.utils").pick_process()
			end,
			cwd = "${workspaceFolder}",
		},
		{
			-- Pairs with `node --inspect` (default port 9229)
			type = "pwa-node",
			request = "attach",
			name = "Attach to :9229",
			port = 9229,
			cwd = "${workspaceFolder}",
		},
	}
	for _, ft in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
		dap.configurations[ft] = configs
	end

	-- js-debug leaves breakpoints sent during the attach handshake stuck as "provisional" when the
	-- script is already loaded, and treats an identical resend as a no-op. Once the target thread
	-- starts, clear and re-send so they bind (also re-runs after `node --watch` restarts).
	dap.listeners.after.event_thread["rebind-js-breakpoints"] = function(session, body)
		if body.reason ~= "started" or session.config.type ~= "pwa-node" then
			return
		end
		local bps = require("dap.breakpoints").get()
		local pending = vim.tbl_count(bps)
		for bufnr in pairs(bps) do
			local clear = { source = { path = vim.api.nvim_buf_get_name(bufnr) }, breakpoints = {} }
			session:request("setBreakpoints", clear, function()
				pending = pending - 1
				if pending == 0 then
					session:set_breakpoints(bps)
				end
			end)
		end
	end
end

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"igorlfs/nvim-dap-view",
			"leoluz/nvim-dap-go",
		},
		init = function()
			vim.api.nvim_create_autocmd("User", { pattern = "VeryLazy", once = true, callback = ensure_adapters })
		end,
		config = function()
			local dap = require("dap")

			require("dap-view").setup({
				-- Open the panels when a session starts, close them when it ends
				auto_toggle = true,
				-- Show variable values at the end of each line while paused
				virtual_text = { enabled = true, position = "eol" },
			})
			require("dap-go").setup()
			setup_js(dap)

			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticHint" })
			vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "Visual" })

			-- nvim-dap swaps the sign to "rejected" while a breakpoint is unverified but never swaps it
			-- back once the adapter verifies it (js-debug always answers "provisional" first)
			local breakpoints = require("dap.breakpoints")
			local set_state = breakpoints.set_state
			breakpoints.set_state = function(bufnr, state)
				set_state(bufnr, state)
				if not state.verified then
					return
				end
				local placed = vim.fn.sign_getplaced(bufnr, { group = "dap_breakpoints", lnum = state.line })[1]
				for _, sign in ipairs(placed and placed.signs or {}) do
					if sign.name == "DapBreakpointRejected" then
						local bp = vim.iter(breakpoints.get(bufnr)[bufnr] or {}):find(function(b)
							return b.line == state.line
						end) or {}
						local name = (bp.condition or "") ~= "" and "DapBreakpointCondition"
							or (bp.logMessage or "") ~= "" and "DapLogPoint"
							or "DapBreakpoint"
						vim.fn.sign_place(sign.id, "dap_breakpoints", name, bufnr, { lnum = state.line, priority = 21 })
					end
				end
			end
		end,
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle breakpoint",
			},
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Condition: "))
				end,
				desc = "Conditional breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Start / continue",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Rerun last session",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step into",
			},
			{
				"<leader>do",
				function()
					require("dap").step_over()
				end,
				desc = "Step over",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_out()
				end,
				desc = "Step out",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Stop session",
			},
			{
				"<leader>dv",
				function()
					require("dap-view").toggle()
				end,
				desc = "Toggle debug panels",
			},
			{
				"<leader>dw",
				function()
					require("dap-view").add_expr()
				end,
				mode = { "n", "v" },
				desc = "Watch expression",
			},
			{
				"<leader>dT",
				function()
					require("dap-go").debug_test()
				end,
				ft = "go",
				desc = "Debug Go test under cursor",
			},
		},
	},
}
