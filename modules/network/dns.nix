{ lib, ... }:
{
  services.resolved = {
    enable = true;
    llmnr = "false";
    dnsovertls = "opportunistic";
    fallbackDns = lib.mkForce [ ];
  };
  systemd.network.enable = lib.mkForce false;
}
