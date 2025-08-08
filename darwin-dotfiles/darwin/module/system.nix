{ pkgs, username, ... }:

{
  security.pam.services.sudo_local.touchIdAuth = true;
  time.timeZone = "Europe/Minsk";

  system = {
    primaryUser = username;
    stateVersion = 6;

    activationScripts = {
      runMyCmd.text = ''
        echo "⚙️  Выполняем кастомную команду" >&2
        mkdir -p /Users/dzmitriy/Documents/projects/own/123
      '';
    };

    defaults = {
      menuExtraClock = {
        ShowDate = 1;
        Show24Hour = false;
        IsAnalog = false;
      };

      dock = {
        autohide = false;
        show-recents = false;
        orientation = "left";
        tilesize = 50;

        wvous-tl-corner = 2;
        wvous-tr-corner = 13;
        wvous-bl-corner = 3;
        wvous-br-corner = 4;

        persistent-apps = [
          { app = "/Applications/Arc.app"; }
          { app = "/Applications/Notion.app"; }
          { app = "/Applications/IntelliJ IDEA.app"; }
          { app = "/System/Applications/Books.app"; }
          { app = "/System/Applications/Passwords.app"; }
          { spacer = { small = true; }; }
          { folder = "/Users/dzmitriy/Documents/system"; }
          { spacer = { small = true; }; }
        ];
      };

      finder = {
        _FXShowPosixPathInTitle = false;
        AppleShowAllExtensions = true;
        AppleShowAllFiles = false;
        CreateDesktop = false;
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        FXRemoveOldTrashItems = true;
        NewWindowTarget = "Documents";
        QuitMenuItem = true;
        ShowExternalHardDrivesOnDesktop = false;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;
        ShowPathbar = false;
        ShowStatusBar = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = false;
      };

      NSGlobalDomain = {
        "com.apple.keyboard.fnState" = true;
        "com.apple.swipescrolldirection" = true;
        "com.apple.sound.beep.feedback" = 0;
        AppleInterfaceStyle = "Dark";
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 3;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };

      CustomUserPreferences = {
        ".GlobalPreferences" = {
          AppleSpacesSwitchOnActivate = true;
        };
        NSGlobalDomain = {
          WebKitDeveloperExtras = true;
        };
        "com.apple.finder" = {
          ShowExternalHardDrivesOnDesktop = true;
          ShowHardDrivesOnDesktop = true;
          ShowMountedServersOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
          _FXSortFoldersFirst = true;
          FXDefaultSearchScope = "SCcf";
          ShowRecentTags = false;
        };
        "com.apple.desktopservices" = {
          DSDontWriteNetworkStores = true;
          DSDontWriteUSBStores = true;
        };
        "com.apple.spaces" = {
          "spans-displays" = 0;
        };
        "com.apple.WindowManager" = {
          EnableStandardClickToShowDesktop = 0;
          StandardHideDesktopIcons = 0;
          HideDesktop = 0;
          StageManagerHideWidgets = 0;
          StandardHideWidgets = 0;
        };
        "com.apple.screensaver" = {
          askForPassword = 1;
          askForPasswordDelay = 0;
        };
        "com.apple.screencapture" = {
          location = "~/Desktop";
          type = "png";
        };
        "com.apple.AdLib" = {
          allowApplePersonalizedAdvertising = false;
        };
        "com.apple.ImageCapture".disableHotPlug = true;

        "com.apple.sidebarlists" = {
          systemitems = {
            ShowRecents = false;
          };
          cloudEnabled = false;
          sharedEnabled = false;
          favoritesitems = {
            CustomListItems = [
              { Name = "Applications"; Alias = "/Applications"; }
              { Name = "Downloads"; Alias = "/Users/dzmitriy/Downloads"; }
              { Name = "Documents"; Alias = "/Users/dzmitriy/Documents"; }
              { Name = "dzmitriy"; Alias = "/Users/dzmitriy"; }
            ];
          };
        };
      };

      loginwindow = {
        GuestEnabled = false;
        SHOWFULLNAME = true;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = false;
      remapCapsLockToEscape = true;
      swapLeftCommandAndLeftAlt = false;
    };
  };

  programs.zsh.enable = true;

  environment.shells = [ pkgs.zsh ];

  fonts = {
    packages = with pkgs; [
      material-design-icons
      font-awesome
      nerd-fonts.symbols-only
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.hack
      nerd-fonts.ubuntu-mono
      nerd-fonts.atkynson-mono
    ];
  };
}
