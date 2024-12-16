{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;

  services.xserver.enable = false;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "hyprland";

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [ vulkan-tools ];
}