{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      mpv
      flameshot
      obs-studio 
      yt-dlp 
    ];
}