# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/boot" =
    {
      device = "/dev/nvme0n1p1";
      #device = "/dev/disk/by-uuid/CA65-D1FD";
      fsType = "vfat";
    };
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8302e8e7-c121-473a-8f72-323f3b146e1a";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/c3af737e-51c9-4311-a906-f635f2a5e98d"; }
    ];

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}