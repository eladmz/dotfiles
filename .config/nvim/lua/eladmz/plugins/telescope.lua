return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Current buffer search" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find in buffers" },
		{ "<leader>fc", "<cmd>Telescope git_commits<cr>", desc = "Find in git commits" },
		{ "<leader>fr", "<cmd>Telescope git_bcommits<cr>", desc = "Find in buffer git commits" },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find All Files" },
		{ "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Find in git files" },
		{ "<leader>fg", "<cmd>Telescope git_status<cr>", desc = "Find git changed files" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
		{ "<leader>fj", "<cmd>Telescope command_history<cr>", desc = "Command history" },
		{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
		{ "<leader>fl", "<cmd>Telescope lsp_references<cr>", desc = "Lsp References" },
		{ "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Open recent files" },
		{ "<leader>fa", "<cmd>Telescope live_grep<cr>", desc = "Find string in all files" },
		{ "<leader>fs", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor" },
		{ "<leader>ft", "<cmd>Telescope treesitter<cr>", desc = "Treesitter" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "truncate" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
					},
				},
			},
			pickers = {
				live_grep = {
					file_ignore_patterns = { "node_modules", ".git", ".venv" },
					additional_args = function(_)
						return { "--hidden" }
					end,
				},
				grep_string = {
					file_ignore_patterns = { "node_modules", ".git", ".venv" },
					additional_args = function(_)
						return { "--hidden" }
					end,
				},
				find_files = {
					file_ignore_patterns = { "node_modules", ".git", ".venv" },
					hidden = true,
				},
			},
			extensions = {
				"fzf",
			},
		})

		telescope.load_extension("fzf")
	end,
}
