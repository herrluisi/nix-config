{
  pkgs,
  lib,
  ...
}:
{
  programs = {
    bash = {
      enable = true;

      bashrcExtra = ''
        PS1='\[$(tput setaf 208)\][\u:\w]\\$\[$(tput sgr0)\] '
        HISTSIZE=9999999999

        function set_volume {
          if [ $# -eq 1 ]; then
            if [ $1 -ge 0 ] && [ $1 -le 200 ]; then
              ${lib.getExe' pkgs.pulseaudio "pactl"} set-sink-volume 0 $1%
            else
              echo "This might break your headphones, run manually: , pactl set-sink-volume 0 $1%"
            fi
          fi
        }
      '';

      shellAliases =
        let
          diffstr-path = pkgs.writeShellScript "diffstr.sh" "echo diff <( printf '%s\n' $1 ) <( printf '%s\n' $2 )";
        in
        {
          pwd = "pwd | xclip -selection clipboard";
          dc = "sudo docker compose";
          c = "clear";
          nixos = "cd /etc/nixos/";
          nixvim = "cd /home/uisl/Documents/programming/config_stuff/nixvim-config/";
          diffstr = "sh ${diffstr-path}";
          ".." = "cd ..";
          switch-system = "sudo nixos-rebuild switch --flake /etc/nixos";
          build-system = "sudo nixos-rebuild build --flake /etc/nixos";
          powerprofile = "bash /etc/nixos/scripts/performancecycle.sh";
          new-desktop = "curl -s \"https://api.nasa.gov/planetary/apod?api_key=$(cat /run/secrets/nasa_key)\" | jq -r '.hdurl' | xargs curl -L -o /home/uisl/Documents/my_stuff/picture_of_the_day/latest.jpg";
          newdesktop = "new-desktop";
          nixvim-reinstall = "bash /etc/nixos/scripts/nixvim-reinstall.sh";
        };
    };
  };

  home.packages = with pkgs; [ terminator ];

  home.file.".config/terminator/config".text = ''
    [global_config]
      use_custom_url_handler = True
      enabled_plugins = LaunchpadBugURLHandler, LaunchpadCodeURLHandler, APTURLHandler, TerminalShot, CustomCommandsMenu,>
      ask_before_closing = never
    [keybindings]
      close_window = ""
      next_tab = <Shift><Alt>q
      prev_tab = ""
    [profiles]
      [[default]]
        font = Monospace 10
        background_darkness = 0.95
        use_system_font = False
        show_titlebar = False
        scrollbar_position = hidden
        scrollback_infinite = True
    [layouts]
      [[default]]
        [[[window0]]]
          type = Window
          parent = ""
        [[[child1]]]
          type = Terminal
          parent = window0
      [[SaveLastSessionLayout]]
    [plugins]
  '';
}
