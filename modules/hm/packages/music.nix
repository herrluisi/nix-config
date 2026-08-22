{ pkgs, ... }:
{
  home.packages = with pkgs; [
    abcde                              # automated CD ripping
    cddiscid                          # calculates standard CD IDs
    cdparanoia                         # rips audio CDs without errors
    eject                              # ejects the CD tray
    ffmpeg                             # converts audio and video
    flac                               # lossless audio encoder
    libdiscid                          # MusicBrainz DiscID library
    libnotify                          # sends desktop notifications
    perlPackages.MusicBrainz # MusicBrainz API for abcde
    picard                             # tags music files graphically
    strawberry                         # plays and organizes music
  ];
}
