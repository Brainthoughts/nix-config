require("lazy").setup({
	defaults = {
		lazy = true,
	},
	dev = {
		-- reuse files from pkgs.vimPlugins.*
		path = "<lazyPath>",
		patterns = { "." },
		-- fallback to download
		fallback = true,
	},
	spec = {
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		-- The following configs are needed for fixing lazyvim on nix
		-- force enable telescope-fzf-native.nvim
		{ "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
		-- disable mason.nvim, use programs.neovim.extraPackages
		{ "williamboman/mason-lspconfig.nvim", enabled = false },
		{ "williamboman/mason.nvim", enabled = false },
		-- import/override with your plugins
		{ import = "plugins" },

		-- LazyVim Extras
		{ import = "lazyvim.plugins.extras.lang.clangd" },
		{ import = "lazyvim.plugins.extras.lang.rust" },
		{ import = "lazyvim.plugins.extras.lang.markdown" },

		-- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
		{
			"nvim-treesitter/nvim-treesitter",
			opts = function(_, opts)
				opts.ensure_installed = {}
			end,
		},
	},
})
