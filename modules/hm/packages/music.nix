{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # tag music
    picard
    picard-tools
    
    # play and organize music
    strawberry
  ];
}
