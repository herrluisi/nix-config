{ pkgs, ... }:
{
  home.packages = with pkgs; [
    abcde                              # automated CD ripping
    cddiscid                           # calculates standard CD IDs
    cdparanoia                         # rips audio CDs without errors
    chromaprint                        # detects songs by their audio fingerprint
    eject                              # ejects the CD tray
    ffmpeg                             # converts audio and video
    flac                               # lossless audio encoder
    glyr                               # finds album art
    libdiscid                          # MusicBrainz DiscID library
    libnotify                          # sends desktop notifications
    lrcget                             # timestamp synced lyrics
    perlPackages.MusicBrainz           # MusicBrainz API for abcde
    picard                             # tags music files graphically
    strawberry                         # plays and organizes music
  ];
  
  programs.beets = {
    enable = true;
    settings = {
      directory = "/home/uisl/Documents/music";
      library = "/home/uisl/.config/beets/musiclibrary.blb";
      plugins = "lyrics lastgenre scrub chroma";
      match = {
        max_rec_thresh = 2.0;
      };
      import = {
        write = true;
        copy = false;
        move = false;
        resume = true;
      };
      lyrics = {
        auto = true;
        fallback = "";
      };
      lastgenre = {
        auto = true;
        fallback = "Unbekannt";
      };
      scrub = {
        auto = true;
      };
    };
  };

  home.file.".abcde.conf".text = ''
    # ======================================================================
    # EIGENE FUNKTIONEN FÜR DIE FORMATIERUNG
    # ======================================================================

    # 1. Tracknummer in Buchstaben umwandeln (01 -> aa, 02 -> ab, 26 -> az, 27 -> ba ...)
    num_to_letters() {
        # '10#' verhindert, dass Bash Zahlen wie 08 und 09 fälschlicherweise als Oktalzahl liest
        local n=$(( 10#$1 ))
        # Unser Alphabet als Array
        local alphabet=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
        
        # Berechnung für das 2-Buchstaben-System
        local n1=$(( (n - 1) / 26 ))
        local n2=$(( (n - 1) % 26 ))
        
        # Ausgabe der beiden Buchstaben
        echo "''${alphabet[$n1]}''${alphabet[$n2]}"
    }

    # 2. Namen standardisieren (alles_klein_und_zusammen_geschrieben_umlaute_ausschreiben)
    mungefilename() {
        echo "$@" | sed \
            -e 's/Ä/ae/g' -e 's/ä/ae/g' \
            -e 's/Ö/oe/g' -e 's/ö/oe/g' \
            -e 's/Ü/ue/g' -e 's/ü/ue/g' \
            -e 's/ß/ss/g' \
            | tr '[:upper:]' '[:lower:]' \
            | sed -e 's/[^a-z0-9_]/_/g' -e 's/__*/_/g' -e 's/^_//' -e 's/_$//'
    }

    # ======================================================================
    # STANDARD-EINSTELLUNGEN
    # ======================================================================

    CDDBMETHOD=musicbrainz
    OUTPUTTYPE=flac

    # Zielverzeichnis für die gerippte Musik
    OUTPUTDIR="/home/uisl/Documents/music"

    # NAMENSSCHEMA
    # WICHTIG: Wir nutzen hier den Nix-Escape-Trick $ {"$"}, damit Nix 
    # nicht versucht, die Variablen beim Kompilieren selbst auszuwerten!
    OUTPUTFORMAT='${"$"}{ARTISTFILE}/${"$"}{ALBUMFILE}/$(num_to_letters ${"$"}{TRACKNUM})_${"$"}{TRACKFILE}'
    VAOUTPUTFORMAT='various_artists/${"$"}{ALBUMFILE}/$(num_to_letters ${"$"}{TRACKNUM})_${"$"}{TRACKFILE}'

    # ======================================================================
    # ALBUM COVER SETTINGS
    # ======================================================================

    # Name der Bilddatei im Ordner
    ALBUMARTFILE="cover.jpg"
    ALBUMARTTYPE="JPEG"

    EMBEDALBUMART=y

    ACTIONS=cddb,read,getalbumart,encode,tag,move,clean
    MAXPROCS=4 
    EJECTCD=y
    INTERACTIVE=n
  '';
}
