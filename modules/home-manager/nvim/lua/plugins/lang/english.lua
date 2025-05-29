return {
	"saghen/blink.cmp",
	enabled = true,
	dependencies = {
		"Kaiser-Yang/blink-cmp-dictionary",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	opts = function(_, opts)
		opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
			per_filetype = {
				tex = { inherit_defaults = true, "dict" },
				markdown = { inherit_defaults = true, "dict" },
				text = { inherit_defaults = true, "dict" },
			},
			providers = {
				dict = {
					module = "blink-cmp-dictionary",
					name = "Dict",
					min_keyword_length = 3,
					max_items = 8,
					score_offset = -10,
					opts = {
						dictionary_directories = { vim.fn.expand("~/.config/nvim/lua/plugins/lang/dicts") },
					},
				},
			},
		})
	end,
}
