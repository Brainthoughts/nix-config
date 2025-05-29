{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      # LazyVim
      lua-language-server
      stylua

      # Telescope
      ripgrep

      # markdown
      markdownlint-cli2
      marksman

      # Clang
      clang-tools
      gnumake
      lldb
      bear

      # nix
      nixd
      nixfmt-rfc-style

      # python
      python3
      ruff
      pyright

      # java
      zulu17
      jdt-language-server

      # rust
      rustc
      rustfmt
      cargo
      clippy
      rust-analyzer

      # tex
      texliveFull
      texlab
    ];

    plugins = with pkgs.vimPlugins; [ lazy-nvim ];

    extraLuaConfig =
      let
        plugins = with pkgs.vimPlugins; [
          # colorscheme
          nightfox-nvim

          # markdown
          markdown-preview-nvim
          render-markdown-nvim

          # java
          nvim-jdtls

          # python
          neotest-python
          nvim-dap-python

          # rust
          crates-nvim
          rustaceanvim

          # c
          clangd_extensions-nvim

          # tex
          vimtex

          # ui
          oil-nvim

          # dictionary
          blink-cmp-dictionary

          # LazyVim
          LazyVim
          bufferline-nvim
          blink-cmp
          cmp-buffer
          cmp-nvim-lsp
          cmp-path
          cmp_luasnip
          conform-nvim
          dashboard-nvim
          dressing-nvim
          flash-nvim
          friendly-snippets
          fzf-lua
          gitsigns-nvim
          indent-blankline-nvim
          lazydev-nvim
          lualine-nvim
          neo-tree-nvim
          neoconf-nvim
          neodev-nvim
          noice-nvim
          none-ls-nvim
          nui-nvim
          nvim-cmp
          nvim-dap
          nvim-lint
          nvim-lspconfig
          nvim-notify
          nvim-spectre
          nvim-treesitter
          nvim-treesitter-context
          nvim-treesitter-textobjects
          nvim-ts-autotag
          nvim-ts-context-commentstring
          nvim-web-devicons
          persistence-nvim
          plenary-nvim
          snacks-nvim
          telescope-fzf-native-nvim
          telescope-nvim
          todo-comments-nvim
          tokyonight-nvim
          trouble-nvim
          ts-comments-nvim
          undotree
          vim-illuminate
          vim-startuptime
          which-key-nvim
          {
            name = "LuaSnip";
            path = luasnip;
          }
          {
            name = "catppuccin";
            path = catppuccin-nvim;
          }
          {
            name = "mini.ai";
            path = mini-nvim;
          }
          {
            name = "mini.bufremove";
            path = mini-nvim;
          }
          {
            name = "mini.comment";
            path = mini-nvim;
          }
          {
            name = "mini.indentscope";
            path = mini-nvim;
          }
          {
            name = "mini.pairs";
            path = mini-nvim;
          }
          {
            name = "mini.surround";
            path = mini-nvim;
          }
        ];
        mkEntryFromDrv =
          drv:
          if lib.isDerivation drv then
            {
              name = "${lib.getName drv}";
              path = drv;
            }
          else
            drv;
        lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
      builtins.replaceStrings [ "<lazyPath>" ] [ "${lazyPath}" ] (builtins.readFile ./init.lua);
  };

  # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
  xdg.configFile."nvim/parser".source =
    let
      parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths =
          (pkgs.vimPlugins.nvim-treesitter.withPlugins (
            plugins: with plugins; [
              # c
              c
              # java
              java
              # json
              json
              # nix
              nix
              # markdown
              markdown
              # lua
              lua
              # make
              make
              # python
              python
              # rust
              rust
              ron
            ]
          )).dependencies;
      };
    in
    "${parsers}/parser";

  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ./lua;
}
