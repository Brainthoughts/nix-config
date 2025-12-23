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

      ## Langs
      # Clang
      clang-tools
      gnumake
      lldb
      bear

      # english
      ltex-ls-plus

      # java
      jdk25
      (jdt-language-server.override { jdk = pkgs.jdk25; })
      lombok

      # markdown
      markdownlint-cli2
      marksman

      # nix
      nixd
      nixfmt-rfc-style

      # php
      php84Packages.php-codesniffer
      php84Packages.php-cs-fixer
      phpactor

      # python
      python3
      ruff
      basedpyright
      python313Packages.debugpy

      # rust
      rustc
      rustfmt
      cargo
      clippy
      rust-analyzer

      # svelte
      svelte-language-server

      # tex
      texliveFull
      texlab

      # typescript
      vtsls

      # web
      vscode-langservers-extracted
    ];

    plugins = with pkgs.vimPlugins; [ lazy-nvim ];

    extraLuaConfig =
      let
        plugins = with pkgs.vimPlugins; [
          # colorscheme
          nightfox-nvim

          # color highlighting
          mini-hipatterns

          # dap
          nvim-nio
          nvim-dap
          nvim-dap-ui
          nvim-dap-virtual-text

          # dictionary
          blink-cmp-dictionary

          # tmux
          vim-tmux-navigator

          ## lang
          # c
          clangd_extensions-nvim

          # java
          nvim-jdtls

          # markdown
          markdown-preview-nvim
          render-markdown-nvim

          # python
          neotest-python
          nvim-dap-python

          # rust
          crates-nvim
          rustaceanvim

          # tex
          vimtex

          # ui
          oil-nvim

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
          grug-far-nvim
          indent-blankline-nvim
          lazydev-nvim
          lualine-nvim
          mini-icons
          neo-tree-nvim
          neoconf-nvim
          neodev-nvim
          noice-nvim
          none-ls-nvim
          nui-nvim
          nvim-cmp
          nvim-lint
          nvim-lspconfig
          nvim-notify
          nvim-treesitter.withAllGrammars
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
  # switched to all grammars while wiating for nixpkgs to switch to nvim-treesitter main
  # xdg.configFile."nvim/parser".source =
  #   let
  #     parsers = pkgs.symlinkJoin {
  #       name = "treesitter-parsers";
  #       paths =
  #         (pkgs.vimPlugins.nvim-treesitter.withPlugins (
  #           plugins: with plugins; [
  #             # c
  #             c
  #             cpp
  #             # java
  #             java
  #             # json
  #             json
  #             # nix
  #             nix
  #             # lua
  #             lua
  #             # markdown
  #             markdown
  #             # make
  #             make
  #             # php
  #             php
  #             # python
  #             python
  #             # rust
  #             rust
  #             ron
  #             # web
  #             html
  #             javascript
  #             css
  #             typescript
  #             svelte
  #           ]
  #         )).dependencies;
  #     };
  #   in
  #   "${parsers}/parser";
  #
  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ./lua;
  xdg.configFile."nvim/queries".source = ./queries;
  xdg.configFile."nvim/extra/lombok".source = pkgs.lombok;
}
