return {
	"nvim-mini/mini.map",
	event = "BufReadPost",
	config = function()
		local map = require("mini.map")
		map.setup({
			-- Marks in the map for search matches, git hunks, and LSP diagnostics
			integrations = {
				map.gen_integration.builtin_search(),
				map.gen_integration.gitsigns(),
				map.gen_integration.diagnostic(),
			},
			symbols = { encode = map.gen_encode_symbols.dot("4x2") },
			window = { side = "right", width = 12, winblend = 0 },
		})

		Snacks.toggle
			.new({
				id = "minimap",
				name = "Minimap",
				get = function()
					return map.current.win_data[vim.api.nvim_get_current_tabpage()] ~= nil
				end,
				set = function(state)
					if state then
						map.open()
					else
						map.close()
					end
				end,
			})
			:map("<leader>um")

		-- Open with the first real file instead of on the dashboard
		map.open()
	end,
}
