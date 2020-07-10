{ config, lib, pkgs, ... }:

{
  imports = [
  ];

  boot.initrd.luks.devices = [
    { 
      name = "root";
      device = "/dev/sda2";
      preLVM = true;
    }
  ];
  
  networking.hostName = "bkolera-desktop"; # Define your hostname.

  services.xserver.videoDrivers = ["nvidia"];
}
