{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_22
    python3
    jdk21

    sqlite
    mariadb

    youtrack
    insomnia
    mkcert

    terminator
    appimage-run

    sops
    nixfmt
    nixfmt-tree
    deadnix
  ];
}
