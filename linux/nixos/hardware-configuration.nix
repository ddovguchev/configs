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
    device = "/dev/disk/by-uuid/53fdeb3d-adce-4437-947d-535ee7b8cec6";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0EEC-38BC";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/96a7054a-75e0-4f2c-946a-90bc1f656895"; }
  ];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}