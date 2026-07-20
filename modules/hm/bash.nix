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

        function check_missing_music() {
          local music_dir="''${1:-.}"

          if [ ! -d "$music_dir" ]; then
            echo "Fehler: '$music_dir' ist kein Verzeichnis." >&2
            return 1
          fi

          local artist_dir album_dir disk_dir flac_dir
          local has_disks

          for artist_dir in "$music_dir"/*/; do
            [ -d "$artist_dir" ] || continue

            for album_dir in "$artist_dir"*/; do
              [ -d "$album_dir" ] || continue

              has_disks=0
              for disk_dir in "$album_dir"disk[0-9]*/; do
                [ -d "$disk_dir" ] || continue
                has_disks=1

                flac_dir="''${disk_dir}flac"
                if [ ! -d "$flac_dir" ]; then
                  echo "Kein flac-Ordner: $disk_dir"
                elif [ -z "$(find "$flac_dir" -mindepth 1 -print -quit)" ]; then
                  echo "Leerer flac-Ordner: $disk_dir"
                fi
              done

              if [ "$has_disks" -eq 0 ]; then
                flac_dir="''${album_dir}flac"
                if [ ! -d "$flac_dir" ]; then
                  echo "Kein flac-Ordner: $album_dir"
                elif [ -z "$(find "$flac_dir" -mindepth 1 -print -quit)" ]; then
                  echo "Leerer flac-Ordner: $album_dir"
                fi
              fi
            done
          done
        }
      '';

      shellAliases =
        let
          diffstr-path = pkgs.writeShellScript "diffstr.sh" "echo diff <( printf '%s\n' $1 ) <( printf '%s\n' $2 )";
        in
        {
          ".." = "cd ..";
          build-system = "sudo nixos-rebuild build --flake /etc/nixos";
          c = "clear";
          dc = "sudo docker compose";
          diffstr = "sh ${diffstr-path}";
          music = "cd /home/uisl/Documents/music";
          newdesktop = "new-desktop";
          nixdocs = "cd /home/uisl/Documents/programming/config_stuff/nix-docs";
          nixos = "cd /etc/nixos/";
          nixvim = "cd /home/uisl/Documents/programming/config_stuff/nixvim-config";
          nixvim-reinstall = "bash /etc/nixos/scripts/nixvim-reinstall.sh";
          powerprofile = "bash /etc/nixos/scripts/performancecycle.sh";
          pwd = "pwd | xclip -selection clipboard";
          studium = "cd /home/uisl/Documents/studium/THM";
          studiumprojects = "cd /home/uisl/Documents/studium/THM/projects";
          switch-system = "sudo nixos-rebuild switch --flake /etc/nixos";
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
