{ config, pkgs, ... }:

{
  programs.hyprland.enable = true;

  services = {
    xserver.enable = false;

    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
      defaultSession = "Hyprland";
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ vulkan-tools ];
  };

  environment.systemPackages = with pkgs; [
    vulkan-tools
  ];

  services.displayManager.sddm.environment = {
    "XDG_SESSION_TYPE" = "wayland";
    "XDG_CURRENT_DESKTOP" = "Hyprland";
  };
}