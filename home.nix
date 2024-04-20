{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "rizqirazkafi";
  home.homeDirectory = "/home/rizqirazkafi";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [ hello ];

  home.file = { };

  home.sessionVariables = { EDITOR = "nvim"; };

  # Let Home Manager install and manage itself.
  # programs.home-manager.enable = true;
  # services.picom.enable = true;

  programs.git = {
    enable = true;
    userName = "Rizqirazkafi";
    userEmail = "rizqirazkafi56@gmail.com";
  };

  programs.bash = {
    enable = true;
    shellAliases = { ll = "ls -la"; };
    enableCompletion = true;
    initExtra = ''echo "Hello, what good shall I do today?"'';
  };
  programs.neovim = let
    toLua = str: ''
      lua << EOF
      ${str}
      EOF
    '';
    toLuaFile = file: ''
      lua << EOF
      ${builtins.readFile file}
      EOF
    '';
  in {
    enable = true;
    extraPackages = with pkgs; [
      xclip
      luajitPackages.lua-lsp
      rnix-lsp
      emmet-ls
      nodePackages.typescript-language-server
      javascript-typescript-langserver
      gopls
      eslint_d
      marksman
    ];

    plugins = with pkgs.vimPlugins; [
      vim-tmux-navigator
      nvim-lspconfig
      auto-pairs
      undotree
      {
        plugin = comment-nvim;
        config = toLua ''require("Comment").setup()'';
      }
      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./nvim/plugin/lsp.lua;
      }
      {
        plugin = rose-pine;
        config = "colorscheme rose-pine";
      }
      neodev-nvim
      {
        plugin = nvim-cmp;
        config = toLuaFile ./nvim/plugin/cmp.lua;
      }
      {
        plugin = telescope-nvim;
        config = toLuaFile ./nvim/plugin/telescope.lua;
      }
      {
        plugin = harpoon;
        config = toLuaFile ./nvim/plugin/harpoon.lua;
      }
      {
        plugin = fidget-nvim;
        config = toLuaFile ./nvim/plugin/fidget.lua;
      }
      which-key-nvim
      telescope-fzf-native-nvim
      cmp_luasnip
      cmp-nvim-lsp
      luasnip
      friendly-snippets
      {
        plugin = gitsigns-nvim;
        config = toLuaFile ./nvim/plugin/gitsigns.lua;
      }
      {
        plugin = lualine-nvim;
        config = toLuaFile ./nvim/plugin/lualine.lua;
      }
      {
        plugin = none-ls-nvim;
        config = toLuaFile ./nvim/plugin/none-ls-nvim.lua;
      }
      {
        plugin = (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-json
          p.tree-sitter-javascript
          p.tree-sitter-markdown
          p.tree-sitter-html
          p.tree-sitter-css
        ]));
        config = toLuaFile ./nvim/plugin/treesitter.lua;
      }
      vim-nix
    ];
    extraLuaConfig = "${builtins.readFile ./nvim/options.lua}";
  };

}
