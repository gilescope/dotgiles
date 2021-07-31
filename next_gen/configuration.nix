# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Nvidia needs
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.loader.efi.efiSysMountPoint = "/boot/EFI";
  #boot.loader.grub = {
  #  enable = true;
  #  device = "nodev";
  #  version = 2;
  #  efiSupport = true;
  #  enableCryptodisk = true;
  #};

  boot.initrd.luks.devices = {
    root = {
    device = "/dev/disk/by-uuid/db44e7df-a06c-43a9-bd99-ff63a58198bd";
    preLVM = true;
    };
  };
  boot.tmpOnTmpfs = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.enp6s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LANGUAGE = "en_UF.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  # services.xserver.layout = "uk";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gilescope = {
     isNormalUser = true;
     extraGroups = [ "wheel" "audio" "video" "docker" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     #vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     neovim
     wget
     firefox
     home-manager
     fish
     wezterm
     unzip
     direnv
     ntfs3g
     psmisc	
    

     xorg.libxcb # steam dependency
     glibcLocales # probably not needed - if gnome-terminal still works then ditch
 
     gnupg22
     yubikey-personalization
  ];

  nixpkgs.overlays = [
    (self: super: {
      neovim = super.neovim.override {
        viAlias = true;
      };
    })
  ];

  environment.sessionVariables = {
    	LOCAL_ARCHIVE = "$(readlink ~/.nix-profile/lib/locale)/locale-archive";
	EDITOR = "vi";
        SSH_AUTH_SOCK="/run/user/1000/gnupg/S.gpg-agent.ssh";
        # Don't do this as nix doesn't support it: NIX_BUILD_SHELL="/run/current-system/sw/bin/zsh";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.ssh.startAgent = false;
  programs.gnupg = {
    package = pkgs.gnupg22;
    agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # List services that you want to enable:

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  nix.useSandbox = true;
  nix.buildCores = 0;
 
  services.pcscd.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

