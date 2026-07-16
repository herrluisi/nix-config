{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # convert music
    ffmpeg

    # tag music
    picard
    picard-tools
    
    # play and organize music
    strawberry
  ];
}
