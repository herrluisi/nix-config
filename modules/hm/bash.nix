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
        
        # Converts a 0-based index into a two-letter code: 0->aa, 1->ab, ..., 25->az, 26->ba, ...
        function _idx_to_letters() {
          local n=$1
          local first=$(( n / 26 ))
          local second=$(( n % 26 ))
          local a_ord=97  # ascii 'a'
          printf "\\$(printf '%03o' $((a_ord + first)))\\$(printf '%03o' $((a_ord + second)))"
        }

        function rename_tracks() {
          local artist="$1"
          local tracklist="''${2:-tracklist.txt}"

          if [ -z "$artist" ]; then
            echo "Fehler: Bitte Artist als erstes Argument angeben."
            echo "Nutzung: rename_tracks \"Artist Name\" [tracklist.txt]"
            return 1
          fi

          if [ ! -f "$tracklist" ]; then
            echo "Fehler: '$tracklist' nicht gefunden."
            return 1
          fi

          local artist_clean
          artist_clean=$(echo "$artist" | tr ' ' '_' | tr -cd '[:alnum:]_-')

          local i=1
          local idx=0
          while IFS= read -r title || [ -n "$title" ]; do
            [ -z "$title" ] && continue

            local title_clean
            title_clean=$(echo "$title" | tr ' ' '_' | tr -cd '[:alnum:]_-')

            local code src dest
            code=$(_idx_to_letters "$idx")
            src="Track ''${i}.wav"
            dest="''${code}-''${title_clean}-''${artist_clean}.wav"

            if [ -f "$src" ]; then
              mv -- "$src" "$dest"
              echo "Umbenannt: $src -> $dest"
            else
              echo "Warnung: '$src' nicht gefunden, übersprungen."
            fi

            i=$((i+1))
            idx=$((idx+1))
          done < "$tracklist"
        }

        function process_music() {
          rename_tracks "$1" "$2" || return 1
          find . -name "*.wav" -print0 | parallel -0 -j+0 'ffmpeg -i "{}" -c:a flac -compression_level 8 "{.}.flac"'
          mkdir ../flac/
          mv *.flac ../flac/
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
