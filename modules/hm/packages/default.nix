{ pkgs, ... }:
{
  imports = [
    ./office.nix
    ./dev.nix
  ];

  home.packages = with pkgs; [
    # TODO
  ];

  programs.direnv.enable = true;
}
