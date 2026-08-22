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
    
    # 1. Stoppuhr START
    START_TIME=$(date +%s)
    
    # 2. Der exklusive Rip-Vorgang
    if ${pkgs.abcde}/bin/abcde -N -d /dev/sr0 >> "$LOGFILE" 2>&1; then
      
      # 3. Stoppuhr ENDE und Dauer berechnen
      END_TIME=$(date +%s)
      DURATION=$((END_TIME - START_TIME))
      
      # 4. Album-Infos aus den frischen FLAC-Dateien auslesen
      MUSIC_DIR="/home/dein_benutzer/Musik"
      
      # Findet die zuletzt erstellte FLAC-Datei
      LATEST_FLAC=$(find "$MUSIC_DIR" -type f -name "*.flac" -printf "%T@ %p\n" | sort -n | tail -1 | cut -d' ' -f2-)
      ALBUM_DIR=$(dirname "$LATEST_FLAC")
      
      # Metadaten auslesen (löscht alles vor dem ersten "=" weg und nimmt nur die erste Zeile)
      ALBUM=$(${pkgs.flac}/bin/metaflac --show-tag=ALBUM "$LATEST_FLAC" | head -n 1 | sed 's/^[^=]*=//')
      ARTIST=$(${pkgs.flac}/bin/metaflac --show-tag=ARTIST "$LATEST_FLAC" | head -n 1 | sed 's/^[^=]*=//')
      
      # Zählt, wie viele .flac Dateien in dem neuen Album-Ordner liegen
      TRACKS=$(find "$ALBUM_DIR" -type f -name "*.flac" | wc -l)
      
      # 5. Daten in die CSV-Datei schreiben
      CSV_FILE="$LOGDIR/rip_times.csv"
      
      # Falls die CSV noch nicht existiert, erstellen wir schnell die Kopfzeile
      if [ ! -f "$CSV_FILE" ]; then
        echo "Datum,Künstler,Album,Tracks,Dauer_Sekunden" > "$CSV_FILE"
      fi
      
      # Hängt den neuen Datensatz in die nächste freie Zeile an
      echo "$(date +%Y-%m-%d),\"$ARTIST\",\"$ALBUM\",$TRACKS,$DURATION" >> "$CSV_FILE"
      
      # Wir können die neuen Variablen sogar in der Desktop-Benachrichtigung nutzen!
      ${pkgs.libnotify}/bin/notify-send -a "MusicBrainz Ripper" -i audio-x-generic "Rip abgeschlossen" "$ALBUM ($TRACKS Tracks)\nDauer: $DURATION Sekunden." || true
      
      # === HIER WÜRDE NUN DEIN RCLONE UPLOAD STARTEN ===
      
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
