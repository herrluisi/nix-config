{ config, pkgs, ... }:
let
  autoripScript = pkgs.writeShellScriptBin "autorip-script" ''
    # Nix-Magie: Wir füllen den leeren Systemd-PATH explizit mit eject und hostname (nettools) auf
    export PATH="${pkgs.lib.makeBinPath [ pkgs.eject pkgs.nettools ]}:$PATH"

    LOGDIR="$HOME/.abcde"
    LOGFILE="$LOGDIR/autorip.log"
    
    mkdir -p "$LOGDIR"
    
    echo -e "\n========================================================" >> "$LOGFILE"
    echo "Starte Auto-Rip Vorgang: $(date)" >> "$LOGFILE"
    
    ${pkgs.libnotify}/bin/notify-send -a "MusicBrainz Ripper" -i media-optical "Audio-CD erkannt" "Der Rip-Vorgang startet..." || true
    
    if ${pkgs.abcde}/bin/abcde -N -d /dev/sr0 >> "$LOGFILE" 2>&1; then
      echo "Erfolgreich beendet: $(date)" >> "$LOGFILE"
      ${pkgs.libnotify}/bin/notify-send -a "MusicBrainz Ripper" -i audio-x-generic "Vorgang abgeschlossen" "Die CD wurde erfolgreich in FLAC gerippt." || true
    else
      echo "Fehler aufgetreten: $(date)" >> "$LOGFILE"
      ${pkgs.libnotify}/bin/notify-send -a "MusicBrainz Ripper" -i dialog-error "Fehler beim Rippen" "Vorgang abgebrochen. Details siehe: $LOGFILE" || true
    fi
  '';
in

{
  sops.secrets.nasa_key = {
    format = "yaml";
  };

  ### BACKGROUND IMAGE NASA APOD ###
  systemd.user.services.desktop-background = {
    unitConfig = {
      Description = "Sets the background image to the astronomy picture of the day from NASA";
      After = [ "network-online.target" ];
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "curl -s 'https://api.nasa.gov/planetary/apod?api_key=${config.sops.secrets.nasa_key.path}' | jq -r '.hdurl' | xargs curl -L -o /home/uisl/Documents/my_stuff/picture_of_the_day/latest.jpg";
    };
  };

  systemd.user.timers.desktop-background = {
    unitConfig = {
      Description = "Daily timer to set desktop background image from NASA APOD";
    };
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "desktop-background.service";
    };
  };
  
  ### AUTO-RIP AUDIO CD ###
  systemd.user.services.autorip-cd = {
    description = "Auto-Rip Audio CD in FLAC";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${autoripScript}/bin/autorip-script";
      Environment = "PATH=/run/current-system/sw/bin:/etc/profiles/per-user/%u/bin";
      PassEnvironment = "/home/uisl/music_autogen_data";
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="block", KERNEL=="sr0", ACTION=="change", ENV{ID_CDROM_MEDIA_TRACK_COUNT_AUDIO}=="?*", RUN+="${pkgs.su}/bin/su uisl -c 'XDG_RUNTIME_DIR=/run/user/1000 ${pkgs.systemd}/bin/systemctl --user --no-block start autorip-cd.service'"
  '';
}
