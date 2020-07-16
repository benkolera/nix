{ config, lib, pkgs, ... }:

{
  imports = [
    /etc/nixos/obsidian
    /etc/nixos/private
  ];

  boot.initrd.luks.devices = {
    root = { 
      device = "/dev/disk/by-uuid/c53e71f4-4a1e-4e78-9886-e37ae9605801";
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
