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
    imagemagick                        # required by beets to process/resize album art
    libdiscid                          # MusicBrainz DiscID library
    libnotify                          # sends desktop notifications
    lrcget                             # timestamp synced lyrics
    perlPackages.MusicBrainz           # MusicBrainz API for abcde
    picard                             # tags music files graphically
    rsgain                             # calculate replay gain
    strawberry                         # plays and organizes music
  ];
  
  programs.beets = {
    enable = true;
    settings = {
      directory = "/home/uisl/Documents/music";
      library = "/home/uisl/.config/beets/musiclibrary.blb";
      
      # Added fetchart, embedart, replaygain, and mbsync for maximum metadata
      plugins = "lyrics lastgenre scrub chroma fetchart embedart replaygain mbsync";
      
      match = {
        max_rec_thresh = 2.0;
      };
      
      import = {
        write = true;
        copy = false;
        move = false;
        resume = true;
      };
      
      # --- PLUGIN CONFIGURATION ---
      
      lyrics = {
        auto = true;
        fallback = "";
      };
      
      lastgenre = {
        auto = true;
        fallback = "Unknown";
        source = "track"; # Fetches genre for the specific track, not just the album
      };
      
      scrub = {
        auto = true;
      };
      
      # 1. Fetch missing album art from the web (if abcde didn't find one)
      fetchart = {
        auto = true;
        minwidth = 500;
        enforce_ratio = true;
      };
      
      # 2. Embed album art directly into the FLAC file
      embedart = {
        auto = true;
        remove_art_file = false; # Keeps the cover.jpg in the directory for other players
      };
      
      # 3. Calculate ReplayGain (volume normalization) and save it as a tag
      replaygain = {
        auto = true;
        backend = "command";
        command = "rsgain"; # Uses the rsgain package from your home.packages list
      };
      
      # 4. MusicBrainz Sync: Keeps metadata up-to-date if the database changes
      mbsync = {
        auto = false; # Called manually via 'beet mbsync'
      };
    };
  };

  home.file.".abcde.conf".text = ''
    # ======================================================================
    # CUSTOM FUNCTIONS FOR FORMATTING
    # ======================================================================

    # 1. Convert track numbers to letters (01 -> aa, 02 -> ab, 26 -> az, 27 -> ba ...)
    num_to_letters() {
        # '10#' prevents Bash from misinterpreting numbers like 08 and 09 as octal
        local n=$(( 10#$1 ))
        # Our alphabet as an array
        local alphabet=(a b c d e f g h i j k l m n o p q r s t u v w x y z)
        
        # Calculation for the 2-letter system
        local n1=$(( (n - 1) / 26 ))
        local n2=$(( (n - 1) % 26 ))
        
        # Output the two letters
        echo "''${alphabet[$n1]}''${alphabet[$n2]}"
    }

    # 2. Standardize names (all_lowercase_and_connected_umlauts_expanded)
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
    # STANDARD SETTINGS
    # ======================================================================

    CDDBMETHOD=musicbrainz
    OUTPUTTYPE=flac

    # Target directory for ripped music
    OUTPUTDIR="/home/uisl/Documents/music"

    # NAMING SCHEME
    # IMPORTANT: We use the Nix escape trick $ {"$"} so Nix 
    # doesn't try to evaluate the variables during compilation!
    OUTPUTFORMAT='${"$"}{ARTISTFILE}/${"$"}{ALBUMFILE}/$(num_to_letters ${"$"}{TRACKNUM})_${"$"}{TRACKFILE}'
    VAOUTPUTFORMAT='various_artists/${"$"}{ALBUMFILE}/$(num_to_letters ${"$"}{TRACKNUM})_${"$"}{TRACKFILE}'

    # ======================================================================
    # ALBUM ART SETTINGS
    # ======================================================================

    # Name of the image file in the directory
    ALBUMARTFILE="cover.jpg"
    ALBUMARTTYPE="JPEG"

    EMBEDALBUMART=y

    ACTIONS=cddb,read,getalbumart,encode,tag,move,clean
    MAXPROCS=4 
    EJECTCD=y
    INTERACTIVE=n
  '';
}
