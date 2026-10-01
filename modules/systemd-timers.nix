{ config, pkgs, ... }:
let
  autoripScript = pkgs.writeShellScriptBin "autorip-script" ''
    export PATH="${pkgs.lib.makeBinPath [ pkgs.eject pkgs.nettools pkgs.curl pkgs.jq pkgs.flac pkgs.cdparanoia ]}:$PATH"

    LOGDIR="$HOME/.abcde"
    LOGFILE="$LOGDIR/autorip.log"
    
    mkdir -p "$LOGDIR"
    
    echo -e "\n========================================================" >> "$LOGFILE"
    echo "Starte Auto-Rip Vorgang: $(date)" >> "$LOGFILE"
    
    ${pkgs.libnotify}/bin/notify-send -a "MusicBrainz Ripper" -i media-optical "Audio-CD erkannt" "Suche in MusicBrainz..." || true
    
    START_TIME=$(date +%s)
    
    # VERSUCH 1: Der intelligente Rip über abcde
    if ${pkgs.abcde}/bin/abcde -N -d /dev/sr0 >> "$LOGFILE" 2>&1; then
      
      END_TIME=$(date +%s)
      DURATION=$((END_TIME - START_TIME))
      MUSIC_DIR="/home/uisl/Documents/music"
      
      LATEST_FLAC=$(find "$MUSIC_DIR" -type f -name "*.flac" -printf "%T@ %p\n" | sort -n | tail -1 | cut -d' ' -f2-)
      ALBUM_DIR=$(dirname "$LATEST_FLAC")
      
      ALBUM=$(metaflac --show-tag=ALBUM "$LATEST_FLAC" | head -n 1 | sed 's/^[^=]*=//')
      ARTIST=$(metaflac --show-tag=ARTIST "$LATEST_FLAC" | head -n 1 | sed 's/^[^=]*=//')
      
      # Konvertiert ARTIST und ALBUM in Kleinbuchstaben und sucht nach "unknown"
      if [[ "''${ARTIST,,}" == *"unknown"* ]] || [[ "''${ALBUM,,}" == *"unknown"* ]]; then
          
          DUMMY_DIR="$HOME/Downloads/temp_rip_$(date +%Y%m%d_%H%M%S)"
          mkdir -p "$DUMMY_DIR"
          
          # Verschiebt alle FLACs sofort aus der sauberen Bibliothek in den Dummy-Ordner
          mv "$ALBUM_DIR"/*.flac "$DUMMY_DIR"/
          
          # Räumt die unschönen "unknown_artist"-Ordner direkt wieder weg
          rm -rf "$ALBUM_DIR"
          rmdir "$(dirname "$ALBUM_DIR")" 2>/dev/null || true
          
          ${pkgs.libnotify}/bin/notify-send -a "MusicBrainz Ripper" -i dialog-warning "Unbekannte CD" "CD wurde gerippt, aber nicht erkannt!\n\nVerschoben nach:\n$DUMMY_DIR\n\nFühre aus:\nbeet import -s -m $DUMMY_DIR" -t 15000 || true
          
          eject /dev/sr0 || true
          exit 0
      fi
      # =================================================================
      
      TRACKS=$(find "$ALBUM_DIR" -type f -name "*.flac" | wc -l)
      
      # CSV Eintrag
      CSV_FILE="$LOGDIR/rip_times.csv"
      if [ ! -f "$CSV_FILE" ]; then
        echo "Datum,Künstler,Album,Tracks,Dauer_Sekunden" > "$CSV_FILE"
      fi
      echo "$(date +%Y-%m-%d),\"$ARTIST\",\"$ALBUM\",$TRACKS,$DURATION" >> "$CSV_FILE"
      
      ${pkgs.libnotify}/bin/notify-send -a "MusicBrainz Ripper" -i audio-x-generic "Rip abgeschlossen" "$ALBUM ($TRACKS Tracks)\nLade nun Songtexte über LRCLIB herunter..." || true
      
      # LRCLIB LYRICS DOWNLOAD
      cd "$ALBUM_DIR"
      for file in *.flac; do
          if [ -f "''${file%.flac}.lrc" ]; then continue; fi
          
          TRACK_TITLE=$(metaflac --show-tag=TITLE "$file" | head -n 1 | sed 's/^[^=]*=//')
          TRACK_ARTIST=$(metaflac --show-tag=ARTIST "$file" | head -n 1 | sed 's/^[^=]*=//')
          
          if [ -z "$TRACK_TITLE" ] || [ -z "$TRACK_ARTIST" ]; then continue; fi
          
          RESPONSE=$(curl -s -G --data-urlencode "artist_name=$TRACK_ARTIST" --data-urlencode "track_name=$TRACK_TITLE" --data-urlencode "album_name=$ALBUM" "https://lrclib.net/api/get")
          SYNCED=$(echo "$RESPONSE" | jq -r '.syncedLyrics | select(. != null)')
          
          if [ -n "$SYNCED" ]; then
              echo "$SYNCED" > "''${file%.flac}.lrc"
          fi
          sleep 1
      done
      
      ${pkgs.libnotify}/bin/notify-send -a "MusicBrainz Ripper" -i text-x-generic "Lyrics fertig" "Texte für '$ALBUM' geladen." || true

    # VERSUCH 2: Der "Dumb Rip" Fallback (Wenn abcde die CD nicht kennt)
    else
      echo "abcde fehlgeschlagen (unbekannte CD). Starte RAW-Rip Fallback..." >> "$LOGFILE"
      ${pkgs.libnotify}/bin/notify-send -a "MusicBrainz Ripper" -i dialog-warning "Unbekannte CD" "MusicBrainz kennt die CD nicht.\nStarte RAW-Rip für Beets Akustik-Scan..." || true
      
      # Eindeutigen Dummy-Ordner mit Zeitstempel erstellen
      DUMMY_DIR="$HOME/Downloads/temp_rip_$(date +%Y%m%d_%H%M%S)"
      mkdir -p "$DUMMY_DIR"
      cd "$DUMMY_DIR"
      
      # Komplett roh auslesen
      if cdparanoia -B -d /dev/sr0 >> "$LOGFILE" 2>&1; then
        
        # Direkt in FLAC umwandeln und WAVs löschen
        for f in *.wav; do
          if [ -f "$f" ]; then
            flac -8 "$f" >> "$LOGFILE" 2>&1 && rm "$f"
          fi
        done
        
        # CD auswerfen
        eject /dev/sr0 || true
        
        ${pkgs.libnotify}/bin/notify-send -a "MusicBrainz Ripper" -i audio-x-generic "RAW-Rip fertig" "Unbekannte CD liegt bereit in:\n$DUMMY_DIR\n\nFühre nun aus:\nbeet import -s -m $DUMMY_DIR" -t 15000 || true
        
      else
        echo "Auch der RAW-Rip mit cdparanoia ist fehlgeschlagen." >> "$LOGFILE"
        ${pkgs.libnotify}/bin/notify-send -a "MusicBrainz Ripper" -i dialog-error "Kritischer Fehler" "Die CD konnte nicht gelesen werden. Evtl. Kratzer oder Kopierschutz?" || true
        eject /dev/sr0 || true
      fi
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
      PassEnvironment = "/home/uisl/music_autogen_data/";
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="block", KERNEL=="sr0", ACTION=="change", ENV{ID_CDROM_MEDIA_TRACK_COUNT_AUDIO}=="?*", RUN+="${pkgs.su}/bin/su uisl -c 'XDG_RUNTIME_DIR=/run/user/1000 ${pkgs.systemd}/bin/systemctl --user --no-block start autorip-cd.service'"
  '';
}
