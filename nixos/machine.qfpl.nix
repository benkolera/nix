{ config, lib, pkgs, ... }:

{
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/nvme0n1p2";
      preLVM = true;
    }
  ];

  networking.hostName = "bkolera-qfpl"; # Define your hostname.

  services.xserver.videoDrivers = ["intel"];
}
