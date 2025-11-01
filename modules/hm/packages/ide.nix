{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      stablePkgs.jetbrains.webstorm
      stablePkgs.jetbrains.pycharm-professional
      stablePkgs.jetbrains.jdk
      stablePkgs.jetbrains.idea-ultimate
      stablePkgs.jetbrains.datagrip
      stablePkgs.jetbrains-mono
      stablePkgs.jetbrains.rust-rover
      android-studio
    ];
}
