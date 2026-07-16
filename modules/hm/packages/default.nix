{
  imports = [
    ./communication.nix
    ./devtools.nix
    ./games.nix
    ./ide.nix
    ./media.nix
    ./music.nix
    ./networking.nix
    ./office.nix
    ./textediting.nix
  ];

  programs.direnv.enable = true;
}
