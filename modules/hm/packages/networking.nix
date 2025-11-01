{ pkgs, ... }:
{
  home.packages = with pkgs; [
    openconnect # VPN Connection for THM
    openvpn

  ];
}
