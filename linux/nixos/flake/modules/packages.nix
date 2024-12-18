{ pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = ["python-2.7.18.8" "electron-25.9.0"];
  };

  environment.systemPackages = with pkgs; [
    # Desktop apps
    audacity
    firefox-wayland
    telegram-desktop
    kitty
    obs-studio
    rofi-wayland
    wofi
    mpv
    kdenlive
    discord
    gparted
    obsidian
    pcmanfm-qt
    dmg2img
    
    # Coding stuff
    neovim
    gnumake
    gcc
    nodejs
    python
    (python3.withPackages (ps: with ps; [ requests ]))

    # CLI utils
    vim
    neofetch
    file
    tree
    wget
    git
    fastfetch
    htop
    nix-index
    unzip
    scrot
    ffmpeg
    light
    lux
    mediainfo
    ranger
    zram-generator
    cava
    zip
    ntfs3g
    yt-dlp
    brightnessctl
    swww
    openssl
    lazygit
    bluez
    bluez-tools

    # GUI utils
    feh
    imv
    dmenu
    screenkey
    mako
    gromit-mpx

    # Xorg stuff
    #xterm
    #xclip
    #xorg.xbacklight

    # Wayland stuff
    wl-clipboard
    cliphist
    swaylock

    # WMs and stuff
    herbstluftwm
    hyprland
    swaybg

    seatd
    xdg-desktop-portal-hyprland
    polybar
    waybar


    libinput
    vulkan-tools
    xdg-desktop-portal

    # Sound
    pipewire
    pulseaudio
    pamixer

    # GPU stuff
    amdvlk
    glaxnimate

    # Screenshotting
    grim
    grimblast
    slurp
    flameshot
    swappy

    # Other
    home-manager
    spice-vdagent
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    papirus-nord
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    twemoji-color-font
    font-awesome
    powerline-fonts
    powerline-symbols
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
  ];
}
