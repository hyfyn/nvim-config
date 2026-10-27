-- macOS "Auto" appearance never writes `AppleInterfaceStyle`, so `defaults read`
-- (what auto-dark-mode.nvim polls) reports light while the system is dark.
-- Ask System Events instead, which reports the effective appearance.
local query = { "osascript", "-e", 'tell application "System Events" to tell appearance preferences to get dark mode' }

local function sync_background()
	vim.system(query, { text = true }, function(out)
		if out.code ~= 0 then
			return
		end
		local bg = vim.trim(out.stdout) == "true" and "dark" or "light"
		vim.schedule(function()
			if vim.o.background ~= bg then
				vim.o.background = bg
			end
		end)
	end)
end

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			-- Flavour follows `background`, which the poll below keeps in sync with macOS
			require("catppuccin").setup({
				flavour = "auto",
				background = { light = "latte", dark = "mocha" },
			})
			vim.cmd.colorscheme("catppuccin")

			sync_background()
			vim.uv.new_timer():start(3000, 3000, sync_background)
		end,
	},
}
