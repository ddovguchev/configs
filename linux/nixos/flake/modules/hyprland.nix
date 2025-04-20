{ config, pkgs, ... }:

{
  # GNOME
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;

  # PipeWire (звук)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # OpenGL + Vulkan
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ vulkan-tools ];
  };
}