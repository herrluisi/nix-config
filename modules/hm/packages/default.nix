{ pkgs, ... }:
{
  imports = [
    ./communication.nix
    ./devtools.nix
    ./games.nix
    ./ide.nix
    ./media.nix
    ./networking.nix
    ./office.nix
    ./textediting.nix
  ];

  home.packages = with pkgs; [
    # TODO
  ];

  programs.direnv.enable = true;
}
