{ ... }:

{
  nix.enable = true;

  system.defaults = {
    NSGlobalDomain.AppleInterfaceStyle = "Dark";

    CustomUserPreferences = {
      NSGlobalDomain = {
        NSDocumentSaveNewDocumentsToCloud = false;
        NSNavPanelExpandedStateForSaveMode = false;
        NSNavPanelExpandedStateForSaveMode2 = false;
        PMPrintingExpandedStateForPrint = false;
        PMPrintingExpandedStateForPrint2 = false;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        ApplePressAndHoldEnabled = false;
        KeyRepeat = 2;
        InitialKeyRepeat = 10;
        AppleFontSmoothing = 2;
        AppleShowAllExtensions = true;
      };

      LaunchServices.LSQuarantine = false;

      dock = {
        autohide = true;
        orientation = "right";
        showhidden = true;
        show-recents = false;
        tilesize = 40;
        launchanim = false;
        expose-animation-duration = 0.1;
        dashboard-in-overlay = true;
        mru-spaces = false;
        autohide-delay = 0;
        autohide-time-modifier = 0;
      };

      finder = {
        QuitMenuItem = false;
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = true;
        ShowMountedServersOnDesktop = true;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
        FXDefaultSearchScope = "SCcf";
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
        WarnOnEmptyTrash = false;
      };

      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
      };

      "com.apple.systempreferences".NSQuitAlwaysKeepsWindows = false;

      "com.apple.desktopservices" = {
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };

      "com.apple.screensaver" = {
        askForPassword = 1;
        askForPasswordDelay = 0;
      };

      "com.apple.AdLib".allowApplePersonalizedAdvertising = false;

      "com.apple.BluetoothAudioAgent"."Apple Bitpool Min (editable)" = -40;

      "com.apple.dashboard".mcx-disabled = true;

      "com.apple.DiskUtility" = {
        DUDebugMenuEnabled = true;
        advanced-image-options = true;
      };

      "com.apple.TextEdit" = {
        RichText = 0;
        PlainTextEncoding = 4;
        PlainTextEncodingForWrite = 4;
      };
    };
  };

  networking.applicationFirewall = {
    enable = true;
    enableStealthMode = true;
    # blockAllIncoming = true; # опционально
  };

  system.activationScripts.setup.text = ''
    echo "Applying macOS customizations"

    echo "123" > /Users/dzmitriy/123
    # Printer
    defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

    # Disable Notification Center
    launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2>/dev/null || true

    # Enable HiDPI
    defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

    # Snap-to-grid Finder icons
    plist=~/Library/Preferences/com.apple.finder.plist
    /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" $plist || true
    /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" $plist || true
    /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" $plist || true

    # Expand file info panes
    defaults write com.apple.finder FXInfoPanesExpanded -dict \
      General -bool true \
      OpenWith -bool true \
      Privileges -bool true

    # Terminal UTF-8 and no line marks
    defaults write com.apple.terminal StringEncodings -array 4
    defaults write com.apple.Terminal ShowLineMarks -int 0

    # Disable Siri
    defaults write com.apple.assistant.support 'Assistant Enabled' -bool false
    launchctl disable "user/$UID/com.apple.assistantd"
    launchctl disable "gui/$UID/com.apple.assistantd"
    sudo launchctl disable 'system/com.apple.assistantd'
    launchctl disable "user/$UID/com.apple.Siri.agent"
    launchctl disable "gui/$UID/com.apple.Siri.agent"
    sudo launchctl disable 'system/com.apple.Siri.agent'
    defaults write com.apple.SetupAssistant 'DidSeeSiriSetup' -bool true
    defaults write com.apple.systemuiserver 'NSStatusItem Visible Siri' 0
    defaults write com.apple.Siri 'StatusMenuVisible' -bool false
    defaults write com.apple.Siri 'UserHasDeclinedEnable' -bool true
    defaults write com.apple.assistant.support 'Siri Data Sharing Opt-In Status' -int 2

    # Disable remote services
    sudo launchctl disable 'system/com.apple.tftpd' || true
    sudo launchctl disable 'system/com.apple.telnetd' || true
    sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

    # Apply settings without logout
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
