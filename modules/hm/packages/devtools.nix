{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nodejs_22
    python3
    jdk21
    sqlite
    appimage-run
    mariadb
    youtrack
    insomnia
    mkcert
    terminator
    sops
  ];
}
