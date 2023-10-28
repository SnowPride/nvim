-- Set plugin border style
local BORDER_STYLE = "rounded"

return {
	{
		"nvim-cmp",
		opts = function(_, opts)
			local bordered = require("cmp.config.window").bordered
			return vim.tbl_deep_extend("force", opts, {
				window = {
					completion = bordered(BORDER_STYLE),
					documentation = bordered(BORDER_STYLE),
				},
			})
		end,
	},
	{
		"which-key.nvim",
		opts = { window = { border = BORDER_STYLE } },
	},
	{
		"gitsigns.nvim",
		opts = { preview_config = { border = BORDER_STYLE } },
	},
	{
		"nvim-lspconfig",
		opts = function(_, opts)
			require("lspconfig.ui.windows").default_options.border = BORDER_STYLE
			return opts
		end,
	},
	-- {
	--   "none-ls.nvim",
	--   opts = { border = BORDER_STYLE },
	-- },
	{
		"mason.nvim",
		opts = {
			ui = { border = BORDER_STYLE },
		},
	},
	-- {
	--   "noice.nvim",
	--   opts = {
	--     presets = { lsp_doc_border = true },
	--   },
	-- },
}
