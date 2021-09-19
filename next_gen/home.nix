{ config, pkgs, lib,... }:

let
  cargo_remote = pkgs.callPackage ./cargo-remote.nix {};
  diener = pkgs.callPackage ./diener.nix {};
  rust_analyzer_wrapped = pkgs.callPackage ./rust-analyzer-wrapped.nix {};
  rust_analyzer_cargo_check = pkgs.callPackage ./rust-analyzer-cargo-check.nix {
    cargo-remote = cargo_remote;
    useCargoRemote = false;
    #useCargoRemote = sysconfig.computerType == "laptop";
  };
in
{
  nixpkgs.config.allowUnfree = true;

  #self: super: 
  #{
  #  unstable = import <unstable> { overlays = []; };
  #}  



  #systemd.user = {
  #  startServices = true;
  #
  #  services = {
  #    setxkbmap.Service.ExecStart = lib.mkForce "${pkgs.coreutils}/bin/true";
  #  };
  #};


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.bash = {
    enable = true;
    sessionVariables = {
    };
    bashrcExtra = ''
      export EDITOR=vi
      export PATH=$PATH:/home/gilescope/.cargo/bin
      export GITHUB_USER=gilescope
      '';
  };
  #export RUSTC_WRAPPER=sccache
  

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
#steam's not ready for vulkan
#vulkan-tools
#lutris
#libGL
# temp broken haskellPackages.kmonad
xclip
nix-du
#awscli
#citrix_workspace
#pijul
yubikey-manager
#parted
wasm-pack
#xorg.xmodmap
openssl
ledger-udev-rules
ledger-live-desktop
honggfuzz
act
jetbrains.clion
#signal-desktop
#jupyter
audacity
adoptopenjdk-bin

#handbrake
#inkscape
#gimp
#dropbox
#fzf
#lcov # Gives you genhtml command for coverage generation. See grcov
#emscripten
patchelf # rustc compile uses this.
lldb
#rr
#wireshark
gnumake
#podman
docker
rust_analyzer_wrapped
rust_analyzer_cargo_check
#bintools-unwrapped # for 'ar' that some substrate tests need.
diener
radicle-upstream

# rustc
ninja
cmake
valgrind
swig

yarn
mold
element-desktop
spotify
ipfs
ipfs-cluster
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
#llvmPackages.bintools
nixops
bat
rustup
#carnix
#_1password
#spotify
nodejs
#nodePackages.vsce
#nodePackages.yo
#gimp
tokei
discord
#pijul
#coreutils-prefixed # gpaste
sccache
#nodePackages.node2nix
#hyperfine
_1password-gui
	ripgrep
#	hexyl
        graphviz
#        xsv
 #       fd
        yank # pbcopy for linux
        python3
#        riot-desktop
        direnv
#	thunderbird 
bcompare
lorri
	tmux
        jq
#        jetbrains.clion
#        jetbrains.datagrip
#        htop
        (fontforge.override { withGTK = true; })
      ];
  programs.direnv.enable = true;
  services.lorri.enable = true;

  programs.vscode = {
    enable = true ;

    # Overrides manually-installed extensions, but there are almost none in
    # nixpkgs as of 2020-01-01
    extensions = with pkgs.vscode-extensions; [
      # Nix language support
      #bbenoist.Nix

	  vadimcn.vscode-lldb
      # Wakatime editor plugin
      # WakaTime.vscode-wakatime
      #llvm-org.lldb-vscode
      # Vim bindings
      #vscodevim.vim
    ]

    # To fetch the SHA256, use `nix-prefetch-url` with this template:
    #
    #   https://<publisher>.gallery.vsassets.io/_apis/public/gallery/publisher/<publisher>/extension/<name>/<version>/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage

    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [

  {
    name = "subtle-brackets";
    publisher = "rafamel";
    version = "3.0.0";
    sha256 = "1wqwgjmbr8xr5k9jhpqyaz7j793h9vxbpf2rbwwg9fxj17wx9833";
  }
#  {
#    name = "LiveServer";
#    publisher = "ritwickdey";
#    version = "5.6.1";
#    sha256 = "077arf3hsn1yb8xdhlrax5gf93ljww78irv4gm8ffmsqvcr1kws0";
#  }

#  {
#      name = "org-mode";
#      publisher = "vscode-org-mode";
#      version = "1.0.0";
#      sha256 = "1dp6mz1rb8awrrpig1j8y6nyln0186gkmrflfr8hahaqr668il53";
#  }

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
#    userSettings = {
#      # editor settings
#      "editor.formatOnSave" = true;
#      "editor.minimap.enabled" = false;
#      "editor.fontSize" = 14;
#      "editor.lineHeight" = 24;
#      "editor.fontFamily" = "Audiowide, Hasklig, Overpass Mono, monospace";
#      "editor.fontLigatures" = true;
#      "editor.tabSize" = 4;
#      "editor.rulers" = [100];
#      "editor.renderIndentGuides" = false;
#     "vim.neovimPath" = "/home/giles/.nix-profile/bin/nvim";
#      "vim.enableNeovim" = false;
#      # languages
#      "editor.lineNumbers" = "off";
#      # theme
#      "workbench.colorTheme" = "Cyberdyne 20XX";
#      "editor.matchBrackets" = "never";

      # misc
#      "files.trimTrailingWhitespace" = true;
#      "breadcrumbs.enabled" = true;
#      "git.autofetch" = true;
#      "window.zoomLevel" = 2;
#      "css.validate" = false;
#      "scss.validate" = false;
#      "less.validate" = false;
#      "files.associations" = {
#        "*.css" = "scss";
#        "*.js" = "javascript";
#      };
#    };
  };

  home.file = {
    ".inputrc".text =
      ''
        set editing-mode vi
        set keymap vi-command
#	"\b":backward-kill-word
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

 gtk = {
 	enable = true;
	font.name = "Audiowide Mono";
	theme = {
		name = "Numix";
		package = pkgs.numix-gtk-theme;
	};
};

#  programs.gnome-terminal = {
#    enable = true;
#    profile = {
#      default = true; 
#      transparencyPercent = 0;
#      font = "Audiowide Mono";
#    };
#  };

  home.sessionVariables = {
  };
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-sensible
  vim-toml
  vim-devicons
	  awesome-vim-colorschemes
	  coc-nvim
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
    extraConfig = ''
      set tabstop=4
      set shiftwidth=4
      set softtabstop=4
      set expandtab
	  colorscheme alduin
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
    enable = false;
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
    userEmail = "gilescope@gmail.com";

    extraConfig = {
      core.editor = "vi";
      merge.conflictstyle = "diff3";
      push.default = "current";
      rebase.autostash = true;
      hub.protocol = "git";
      commit.gpgsign = true;
      pull.rebase = false;
      core.pager = "cat";
	  core.excludesfile = "~/.gitignore";
      init.defaultBranch = "main";
      user.signingKey = "8748685515D13EE6D902A1A4631F6352D4A949EF";
      #gpg.program = "/run/current-system/sw/bin/gpg";
    };
  };

  programs.home-manager = {
    path = "...";
  };
}
