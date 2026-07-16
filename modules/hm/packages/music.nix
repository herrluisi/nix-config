{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # convert music
    ffmpeg

    # tag music
    picard
    
    # play and organize music
    strawberry
  ];
}
