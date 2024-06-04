return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	opts = {
		close_if_last_window = true,
		filesystem = {
			bind_to_cwd = true,
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},
		},
		buffers = {
			bind_to_cwd = false,
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},
		},
	},
	keys = {
		{
			"<leader>e",
			-- "<cmd>Neotree toggle<cr>",

			function()
				local root_patterns = { ".git" }
				local root_dir = require("lspconfig").util.root_pattern(unpack(root_patterns))(vim.fn.expand("%:p"))
				require("neo-tree.command").execute({ toggle = true, dir = root_dir })
			end,

			desc = "Toggle file explorer",
		},
	},
}
