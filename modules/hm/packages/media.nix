{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mpv
    obs-studio
    yt-dlp
  ];
}
