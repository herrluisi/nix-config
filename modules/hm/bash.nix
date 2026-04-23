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
        
        function new-desktop() {
          local api_key
          api_key=$(cat /run/secrets/nasa_key)
          local out_dir="/home/uisl/Documents/my_stuff/picture_of_the_day"
          local out_file="$out_dir/latest.jpg"

          # Try downloading the HD image directly
          local hdurl
          hdurl=$(curl -s "https://api.nasa.gov/planetary/apod?api_key=$api_key" | jq -r '.hdurl')

          if [[ -n "$hdurl" && "$hdurl" != "null" ]]; then
            curl -L -o "$out_file" "$hdurl" && echo "Saved HD image to $out_file" && return 0
          fi

          # Fall back to extracting first frame from video
          local url
          url=$(curl -s "https://api.nasa.gov/planetary/apod?api_key=$api_key" | jq -r '.url')

          if [[ -z "$url" || "$url" == "null" ]]; then
            echo "Error: Could not retrieve any URL from APOD API." >&2
            return 1
          fi

          ffmpeg -i "$url" -vframes 1 -update 1 -q:v 2 "$out_file" \
            && echo "Saved video frame to $out_file" \
            || { echo "Error: ffmpeg frame extraction failed." >&2; return 1; }
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
          nixvim = "cd /home/uisl/Documents/programming/config_stuff/nixvim-config";
          nixdocs = "cd /home/uisl/Documents/programming/config_stuff/nix-docs";
          studiumprojects = "cd /home/uisl/Documents/studium/THM/projects";
          studium = "cd /home/uisl/Documents/studium/THM";
          diffstr = "sh ${diffstr-path}";
          ".." = "cd ..";
          switch-system = "sudo nixos-rebuild switch --flake /etc/nixos";
          build-system = "sudo nixos-rebuild build --flake /etc/nixos";
          powerprofile = "bash /etc/nixos/scripts/performancecycle.sh";
          newdesktop = "new-desktop";
          nixvim-reinstall = "bash /etc/nixos/scripts/nixvim-reinstall.sh";
        };
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    terminator
  ];

  
  home.file.".config/terminator/config".text = ''
    [global_config]
      use_custom_url_handler = True
      enabled_plugins = LaunchpadBugURLHandler, LaunchpadCodeURLHandler, APTURLHandler, TerminalShot, CustomCommandsMenu
      ask_before_closing = never
    [keybindings]
      close_window = ""
      next_tab = <Shift><Alt>q
      prev_tab = ""
    [profiles]
      [[default]]
        font = JetBrainsMono Nerd Font Mono 10
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
