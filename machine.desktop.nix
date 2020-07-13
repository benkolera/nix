{ config, lib, pkgs, ... }:

{
  imports = [
    /etc/nixos/obsidian
    /etc/nixos/private
  ];

  boot.initrd.luks.devices = {
    root = { 
      device = "/dev/disk/by-uuid/b08a2a42-8211-4167-b66d-673fee085676";
      preLVM = true;
    };
  };
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };
  
  networking.hostName = "bkolera-desktop"; # Define your hostname.

  services.xserver.videoDrivers = ["nvidia"];
}
