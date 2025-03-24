{ config, pkgs, ... }: {
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      external_bar = "all:0:0";
      layout = "stack";
      auto_balance = "off";
      mouse_modifier = "alt";
      mouse_action2 = "resize";
      mouse_action1 = "move";
      top_padding = 5;
      bottom_padding = 5;
      left_padding = 5;
      right_padding = 5;
      window_gap = 5;
    };
    extraConfig = ''
      yabai -m signal --add event=window_focused   action="sketchybar --trigger window_focus"
      yabai -m signal --add event=window_created   action="sketchybar --trigger windows_on_spaces"
      yabai -m signal --add event=window_destroyed action="sketchybar --trigger windows_on_spaces"

      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^System Information$" manage=off
      yabai -m rule --add app="^System Preferences$" manage=off
      yabai -m rule --add title="Preferences$" manage=off
      yabai -m rule --add title="Settings$" manage=off

      yabai -m space 1 --label todo
      yabai -m space 2 --label productive
      yabai -m space 3 --label chat
      yabai -m space 4 --label utils
      yabai -m space 5 --label code

      yabai -m rule --add app="Reminder" space=todo
      yabai -m rule --add app="Mail" space=todo
      yabai -m rule --add app="Calendar" space=todo
      yabai -m rule --add app="Alacritty" space=productive
      yabai -m rule --add app="Arc" space=productive
      yabai -m rule --add app="Microsoft Teams" space=chat
      yabai -m rule --add app="Slack" space=chat
      yabai -m rule --add app="Signal" space=chat
      yabai -m rule --add app="Messages" space=chat
      yabai -m rule --add app="Spotify" space=utils
      yabai -m rule --add app="Bitwarden" space=utils
      yabai -m rule --add app="Ivanti Secure Access" space=utils
      yabai -m rule --add app="Visual Studio Code" space=code
      yabai -m rule --add app="IntelliJ IDEA" space=code
    '';
  };
}