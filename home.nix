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

patcheld # rustc compile uses this.
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

  programs.vscode = {
    enable = true;

    # Overrides manually-installed extensions, but there are almost none in
    # nixpkgs as of 2020-01-01
    extensions = with pkgs.vscode-extensions; [
      # Nix language support
      bbenoist.Nix

      # Wakatime editor plugin
      # WakaTime.vscode-wakatime

      # Vim bindings
      vscodevim.vim
    ]

    # To fetch the SHA256, use `nix-prefetch-url` with this template:
    #
    #   https://<publisher>.gallery.vsassets.io/_apis/public/gallery/publisher/<publisher>/extension/<name>/<version>/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage

    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [

      # The Nord color scheme
      {
        name = "nord-visual-studio-code";
        publisher = "arcticicestudio";
        version = "0.13.0";
        sha256 = "15c1gcw00lssq1qiqmkxapw2acgnlixy055wh5pgq68brm6fwdq6";
      }

  {
    name = "vscode-lldb";
    publisher = "vadimcn";
    version = "1.4.5";
    sha256 = "1lvnpf6lpn1w1m2gcv6vc3yj1xpz6zb49s3zlqhc4pjm7xrfr34n";
  }

    ];

    # vscode settings.json is made read-only and controlled via this section; editing settings
    # in the ui will reveal what to copy over here.
    userSettings = {
      # editor settings
      "editor.formatOnSave" = true;
      "editor.minimap.enabled" = false;
      "editor.fontSize" = 14;
      "editor.lineHeight" = 24;
      "editor.fontFamily" = "Audiowide, Hasklig, Overpass Mono, monospace";
      "editor.fontLigatures" = true;
      "editor.tabSize" = 4;
      "editor.rulers" = [100];
      "editor.renderIndentGuides" = false;
      "vim.neovimPath" = "/home/giles/.nix-profile/bin/nvim";
      "vim.enableNeovim" = false;
      # languages

      # theme
      "workbench.colorTheme" = "Nord";
      "editor.tokenColorCustomizations" = {
        "[Nord]" = {
          "textMateRules" = [
            {
              "scope" = [ "entity.name.type.purescript" ];
              "settings" = {
                "foreground" = "#88C0D0";
              };
            }
          ];
        };
      };

      # misc
      "files.trimTrailingWhitespace" = true;
      "breadcrumbs.enabled" = true;
      "git.autofetch" = true;
      "window.zoomLevel" = 2;
      "css.validate" = false;
      "scss.validate" = false;
      "less.validate" = false;
      "files.associations" = {
        "*.css" = "scss";
        "*.js" = "javascript";
      };
    };
  };

  home.file = {
    ".inputrc".text =
      ''
        set editing-mode vi
        set keymap vi-command
      '';
    "/home/giles/.config/Code/User/keybindings.json".text = ''
    [{
        "command": "vscode-neovim.compositeEscape1",
        "key": "j",
        "when": "neovim.mode == insert",
        "args": "j"
    }]
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
      set number relativenumber
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
