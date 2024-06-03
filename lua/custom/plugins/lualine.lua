return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	init = function()
		vim.g.lualine_laststatus = vim.o.laststatus
		if vim.fn.argc(-1) > 0 then
			-- set an empty statusline till lualine loads
			vim.o.statusline = " "
		else
			-- hide the statusline on the starter page
			vim.o.laststatus = 0
		end
	end,
	opts = function()
		-- PERF: we don't need this lualine require madness 🤷
		-- local lualine_require = require("lualine_require")
		-- lualine_require.require = require
		--
		local icons = require("core.icons")
		--
		-- vim.o.laststatus = vim.g.lualine_laststatus
		--
		return {
			options = {
				theme = "auto",
				globalstatus = true,
				component_separators = "|",
				section_separators = "",
				disabled_filetypes = {
					statusline = {
						"dashboard",
						"alpha",
						"starter",
						"dap-repl",
						"dapui_breakpoints",
						"dapui_console",
						"dapui_scopes",
						"dapui_watches",
						"dapui_stacks",
					},
					winbar = {
						"dap-repl",
						"dapui_breakpoints",
						"dapui_console",
						"dapui_scopes",
						"dapui_watches",
						"dapui_stacks",
					},
				},
			},
			sections = {
				-- lualine_a = { "mode" },
				lualine_b = {
					"branch",
					{
						"diagnostics",
						symbols = {
							error = icons.diagnostics.Error,
							warn = icons.diagnostics.Warn,
							info = icons.diagnostics.Info,
							hint = icons.diagnostics.Hint,
						},
					},
				},

				lualine_c = {
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					{ "filename" },
				},
				lualine_x = {
					{
						"diff",
						symbols = {
							added = icons.git.added,
							modified = icons.git.modified,
							removed = icons.git.removed,
						},
						source = function()
							local gitsigns = vim.b.gitsigns_status_dict
							if gitsigns then
								return {
									added = gitsigns.added,
									modified = gitsigns.changed,
									removed = gitsigns.removed,
								}
							end
						end,
					},
					{
						function()
							local msg = ""
							local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
							local clients = vim.lsp.get_active_clients()
							if next(clients) == nil then
								return msg
							end
							for _, client in ipairs(clients) do
								local filetypes = client.config.filetypes
								if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
									return client.name
								end
							end
							return msg
						end,
					},
				},
			},
			extensions = { "neo-tree", "lazy" },
		}
	end,
}
