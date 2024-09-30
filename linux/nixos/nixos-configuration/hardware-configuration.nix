{ config, lib, pkgs, modulesPath, ... }:

let
  nixosHardware = builtins.fetchGit {
    url = "https://github.com/NixOS/nixos-hardware.git";
  };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    "${nixosHardware}/apple/t2"
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/81d4ba4e-5ac8-4ba4-a047-da810bab0455";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BD09-C251";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/321a370e-0181-461c-bcf0-cc9e55ae12f0"; }
  ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}