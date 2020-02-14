# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nixpkgs.config.allowUnfree = true;
  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader = {
	  grub = {
		  device = "nodev";
		  gfxmodeEfi = "1024x768";
		  efiSupport = true;
		  efiInstallAsRemovable = true;
	  };
	  efi.efiSysMountPoint = "/boot/efi";
	  efi.canTouchEfiVariables = false;
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # networking.useDHCP = false;
  # networking.interfaces.wlp3s0.useDHCP = true;

  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
	wirelesstools # inc. iwconfig to make wifi work.
	atk  # don't thing this is needed.
  	wget 
	vim 
	i3status 
	dmenu 
	networkmanagerapplet 
	(steam.override {nativeOnly = false; extraPkgs = pkgs: [ mono gtk3 gtk3-x11 libgdiplus zlib ];}) 
	synapse 
	home-manager
   ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };
  programs.fish = {
	enable = true;
      };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;


  hardware.facetimehd.enable = true;

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];  
  # Enable sound.
  sound.enable = true;
  
  hardware.pulseaudio = { 
	support32Bit = true;
	enable = false; 
  };

  # try to reduce scroll tearing
  services.compton.enable = true;

  services.flatpak.enable = true;

  xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-destop-portal-gtk ];
  # Enable the X11 windowing system.
services.mbpfan = {
    enable = true;
    lowTemp = 61;
    highTemp = 64;
    maxTemp = 84;
  };
   services.xserver = { 
	enable = true;
   	layout = "us";
   	xkbOptions = "escape:swapcaps";
        #videoDrivers = ["ati_unfree"];
  	# Enable touchpad support.
   	libinput.enable = true;
	libinput.naturalScrolling = true;
	libinput.middleEmulation = false;
	libinput.tapping = true;
	libinput.clickMethod = "clickfinger";
	libinput.horizontalScrolling = false;
	libinput.disableWhileTyping = true;
  	# Enable the KDE Desktop Environment.
  	#displayManager.sddm.enable = true;
  	# desktopManager.plasma5.enable = true;
  	desktopManager.xfce.enable = true;
  	displayManager.lightdm.enable = true;
  	windowManager.i3.enable = true;


  synaptics = {
      enable = false;
      dev = "/dev/input/event*";
      twoFingerScroll = true;
      tapButtons = false;
      accelFactor = "0.02";
      buttonsMap = [ 1 3 2 ];
      palmDetect = true;
      additionalOptions = ''
        Option "PalmMinWidth" "8"
	Option "PalmMinZ" "1000"
        Option "VertScrollDelta" "-180" # scroll sensitivity, the bigger the negative number = less sensitive
        Option "HorizScrollDelta" "-180"
        Option "FingerLow" "40"
        Option "FingerHigh" "90"
        Option "Resolution" "270" # Pointer sensitivity, this is for a retina screen, so you'll probably need to change this for an air
      '';
    };
   };
   
   # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.giles = {
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "audio" "video" "docker" ]; # Enable ‘sudo’ for the user.
     initialHashedPassword = "";
   };

  virtualisation.docker.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?

}

