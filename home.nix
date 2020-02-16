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
      export GITHUB_USER=gilescope
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
#parted
wasm-pack
xorg.xmodmap
openssl
fzf
#lcov # Gives you genhtml command for coverage generation. See grcov
#emscripten
patchelf # rustc compile uses this.
lldb
rr
#wireshark
gnumake
gitAndTools.tig
gitAndTools.hub  # hub sync will update your fork!
cmake
pkg-config
#powerline-fonts
#freeciv_gtk
#niv
#xorg.xmodmap
#exa
clang
llvmPackages.bintools
bat
carnix
#_1password
#spotify
#neovim
nodejs
#gimp
#tokei
#pijul
sccache
nodePackages.node2nix
#hyperfine
	ripgrep
#	hexyl
        graphviz
#        xsv
        fd
        yank # pbcopy for linux
        python3
        riot-desktop
        direnv
	thunderbird
	tmux
        jq
        jetbrains.clion
#        jetbrains.datagrip
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
      llvm-org.lldb-vscode
      # Vim bindings
      #vscodevim.vim
    ]

    # To fetch the SHA256, use `nix-prefetch-url` with this template:
    #
    #   https://<publisher>.gallery.vsassets.io/_apis/public/gallery/publisher/<publisher>/extension/<name>/<version>/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage

    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [

      # The Nord color scheme
#      {
#        name = "nord-visual-studio-code";
#        publisher = "arcticicestudio";
#        version = "0.13.0";
#        sha256 = "15c1gcw00lssq1qiqmkxapw2acgnlixy055wh5pgq68brm6fwdq6";
#      }
  {
    name = "subtle-brackets";
    publisher = "rafamel";
    version = "3.0.0";
    sha256 = "1wqwgjmbr8xr5k9jhpqyaz7j793h9vxbpf2rbwwg9fxj17wx9833";
  }

#  {
#    name = "vscode-lldb";
#    publisher = "vadimcn";
#    version = "1.4.5";
#    sha256 = "1lvnpf6lpn1w1m2gcv6vc3yj1xpz6zb49s3zlqhc4pjm7xrfr34n";
#  }
      {
        name = "cyberdyne20xx";
        publisher = "clerian";
        version = "0.0.1";
        sha256 = "0kix0vbqhaqhbmjs3y28qw71xmn5lljf0vpy5ih5h25g2iay82w4";
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
      "editor.lineNumbers" = "off";
      # theme
      "workbench.colorTheme" = "Nord";
      "editor.matchBrackets" = "never";

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
      "/home/giles/.config/fish/functions/fish_prompt.fish".text = ''
function fish_prompt
    set -l code $status
    test $SSH_TTY
    and printf (set_color red)$USER(set_color brwhite)'@'(set_color yellow)(prompt_hostname)' '
    test "$USER" = 'root'; and echo (set_color red)"#"

    if not set -q __git_cb
        set __git_cb (set_color brown)(git branch ^/dev/null | grep \* | sed 's/* //')(set_color normal)""
    end

    test $code -ne 0; and echo (set_color red)"DON'T PANIC."
    echo -n $__git_cb (set_color green)(prompt_pwd)'> '
end
      '';
    };


  home.sessionVariables = {
  };
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-sensible
      nerdtree
      auto-git-diff
      deoplete-rust
      #    rust-vim
      syntastic
      vim-obsession
      vim-airline
      vim-addon-nix
      vim-better-whitespace
      #vim-gitgutter
      vim-surround
      vim-easymotion
    ];
    settings = {
    };
    extraConfig = ''
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set expandtab

      set paste

      let mapleader=","
      let g:EasyMotion_smartcase = 1

      set encoding=utf-8
      set mouse-=a
      set number relativenumber

" <Leader>f{char} to move to {char}
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

      '';
  };

  programs.fish = {
    enable = true;
    shellAbbrs = {
         # Git abbreviations
         "dir" = "ls -l";
         "copy" = "cp";
         "tig" = "tig status";
         "cat" = "bat --paging=never -p";
         "f" = "cd ~/f";
         "p" = "cd ~/p";
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
      hub.protocol = "git";
    };
  };

  programs.home-manager = {
    path = "...";
  };
}
