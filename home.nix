{ config, pkgs, lib,... }:
{
  systemd.user = {
    startServices = true;

    services = {
      setxkbmap.Service.ExecStart = lib.mkForce "${pkgs.coreutils}/bin/true";
    };
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bash = {
    enable = true;
    sessionVariables = {
    };
    bashrcExtra = ''
      export EDITOR=vim
      export RUSTC_WRAPPER=sccache
      export PATH=$PATH:/home/giles/.cargo/bin
      '';
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";
  home.packages = with pkgs; [
  #(citrix_workspace.overrideAttrs (oldAttrs:{ version = "19.12.0"; } ) )
citrix_workspace
#pijul
lldb
gnumake
gitAndTools.tig
cmake
pkg-config
powerline-fonts
freeciv_gtk
niv
#xorg.xmodmap
exa
clang
llvmPackages.bintools
bat
carnix
_1password
spotify
nodejs
gimp
tokei
#pijul
sccache
nodePackages.node2nix
hyperfine
	ripgrep
	hexyl
        graphviz
        xsv
        fd
        python3
        riot-desktop
        direnv
	thunderbird
	tmux
        jq
        jetbrains.clion
        jetbrains.datagrip
        htop
        (fontforge.override { withGTK = true; })
      ];
  programs.direnv.enable = true;
#  services.lorri.enable = true;

  programs.vscode= {
    extensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
      llvm-org.lldb-vscode
      gilescope.arrowkeydebugging
    ];
    userSettings = ''
      {
        "example.setting" = "none";
      }
    '';
  };

  home.sessionVariables = {
  };
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      nerdtree
      auto-git-diff
      deoplete-rust
  #    rust-vim
      syntastic
      vim-airline
      vim-addon-nix
      vim-better-whitespace
      vim-gitgutter
      vim-surround
    ];
    settings = {
    };
    extraConfig = ''
      set mouse=a
    '';
  };

  programs.fish = {
    enable = false;
    shellAbbrs = {
         # Git abbreviations
         "glg" = "git log --color --graph --pretty --oneline";
         "glgb" = "git log --all --graph --decorate --oneline --simplify-by-decoration";
    };

  };
  programs.git = {
    enable = true;
    userName = "Giles Cope";
    userEmail = "giles.cope@gmail.com";

    extraConfig = {
      core.editor = "vim";
      merge.conflictstyle = "diff3";
      push.default = "current";
      rebase.autostash = true;
    };
  };

  programs.home-manager = {
    path = "...";
  };
}
