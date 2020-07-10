{ config, lib, pkgs, ... }:

{
  imports = [
    /etc/nixos/obsidian
    /etc/nixos/private
  ];

  boot.initrd.luks.devices = {
    root = { 
      device = "/dev/sda2";
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
