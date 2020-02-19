{ config, lib, pkgs, ... }:

{
  # This depends on something presetup and checked out! 
  imports = [
    /etc/nixos/obsidian  
    /etc/nixos/private
  ];
  boot.initrd.luks = {
    yubikeySupport = true;
    devices = [
      {
        name = "linux";
        device = "/dev/nvme0n1p3";
        preLVM = true;
        allowDiscards = true;
        yubikey = {
          storage = {
            device = "/dev/nvme0n1p2";
            fsType = "ext4";
            path   = "/linuxsalt";
          };
        };
      }
    ];
  };
  
  fonts.fontconfig.dpi = 82;
 
  networking.hostName = "bkolera"; # Define your hostname.

  services.xserver.videoDrivers = ["nvidia"];
}
