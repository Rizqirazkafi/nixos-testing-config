{ pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [
      ((vim_configurable.override { }).customize {
        name = "vim";
        # Install plugins for example for syntax highlighting of nix files
        vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
          start = [ vim-nix vim-lastplace ];
          opt = [ ];
        };
        vimrcConfig.customRC = ''
                  " your custom vimrc
          				set nu
          				set relativenumber
          				set shiftwidth=2
          				set tabstop=2
          				set softtabstop=2
          				set smartindent
          				set nowrap
          				set undodir=/etc/nixos/vimundodir
          				set undofile
                  set nocompatible
                  set backspace=indent,eol,start
                  " Turn on syntax highlighting by default
                  syntax on
                  " ...
        '';
      })
    ];
}
