return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- Author/date of the cursor line's last commit, shown at end of line
			current_line_blame = true,
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map("n", "]h", function()
					gitsigns.nav_hunk("next")
				end, "Next hunk")
				map("n", "[h", function()
					gitsigns.nav_hunk("prev")
				end, "Prev hunk")
				map("n", "<leader>hp", gitsigns.preview_hunk_inline, "Preview hunk")
				map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")
				map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
				map("n", "<leader>gb", gitsigns.blame_line, "Blame line")
				map("n", "<leader>gD", gitsigns.diffthis, "Diff file against index")

				local config = require("gitsigns.config").config
				Snacks.toggle
					.new({
						id = "git_line_blame",
						name = "Line Blame",
						get = function()
							return config.current_line_blame
						end,
						set = gitsigns.toggle_current_line_blame,
					})
					:map("<leader>ub", { buffer = bufnr })
				Snacks.toggle
					.new({
						id = "git_inline_diff",
						name = "Inline Diff",
						get = function()
							return config.linehl
						end,
						set = function(state)
							gitsigns.toggle_linehl(state)
							gitsigns.toggle_word_diff(state)
							gitsigns.toggle_deleted(state)
						end,
					})
					:map("<leader>ug", { buffer = bufnr })
			end,
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff working tree" },
			{ "<leader>gm", "<cmd>DiffviewOpen main...HEAD<cr>", desc = "Diff branch against main" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
			{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
		},
	},
}
