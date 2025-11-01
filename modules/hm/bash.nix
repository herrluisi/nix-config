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
        PS1='\[\]\[\][\u@\h:\W]\$ \[\] '
        HISTSIZE=9999999cc

        function v6prefix {
          v=$(cat /dev/urandom | tr -dc a-f0-9 | fold -w16 | head -n1)
          echo ''${v:0:4}:''${v:4:4}:''${v:8:4}:''${v:12:4}
        }

        function set_volume {
          if [ $# -eq 1 ]; then
            if [ $1 -ge 0 ] && [ $1 -le 200 ]; then
              ${lib.getExe' pkgs.pulseaudio "pactl"} set-sink-volume 0 $1%
            else
              echo "This might break your headphones, run manually: , pactl set-sink-volume 0 $1%"
            fi
          fi
        }

        export SSH_AUTH_SOCK="$(${pkgs.gnupg}/bin/gpgconf --list-dirs agent-ssh-socket)"

        function mnt {
          # $1 is remote host
          # $2 is remote path
          # $3 is local path (defaults to ./data)

          if [ $# -lt 2 ]; then
            echo "missing args"
            return
          fi

          HOST="''${1}"
          RPATH="''${2}"
          LPATH="''${3:-./data}"

          echo "mounting cryfs://''${HOST}:''${RPATH} on ''${LPATH} ..."

          # ensure mountpoints for sshfs and cryfs exist
          mkdir -p ./.enc ''${LPATH}

          ${lib.getExe pkgs.sshfs} ''${HOST}:''${RPATH} ./.enc
          ${lib.getExe' pkgs.cryfs "cryfs"} ./.enc ''${LPATH}

          # wait for enter to unmount encrypted remote filesystem
          read -p "Press ENTER to unmount..."

          ${lib.getExe' pkgs.cryfs "cryfs-unmount"} ''${LPATH}
          umount ./.enc
          rm -r ''${LPATH} ./.enc
        }

      '';
      shellAliases =
        let
          restart-desktop-path = pkgs.writeShellScript "restart-desktop.sh" "kquitapp5 plasmashell || killall plasmashell && kstart5 plasmashell";
          diffstr-path = pkgs.writeShellScript "diffstr.sh" "echo diff <( printf '%s\n' $1 ) <( printf '%s\n' $2 )";
        in
        {
          pwd = "pwd | xclip -selection clipboard";
          dc = "sudo docker compose";
          c = "clear";
          nixos = "cd /etc/nixos/";
          restartdesktop = "sh ${restart-desktop-path}";
          diffstr = "sh ${diffstr-path}";
          ".." = "cd ..";
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
