-- Code
vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Apply all auto-fixable lint fixes (oxlint, eslint, etc.)
vim.keymap.set("n", "<leader>cl", function()
	vim.lsp.buf.code_action({
		context = { only = { "source.fixAll" }, diagnostics = {} },
		apply = true,
	})
end, { desc = "Fix all lint errors" })

-- Jump between diagnostics
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })

-- Toggles (which-key shows each one's on/off state)
Snacks.toggle.inlay_hints():map("<leader>uh")
Snacks.toggle.diagnostics():map("<leader>ud")
