{ lib, ... }:
{
  networking.nameservers = [ "1.1.1.1" ];
  services.resolved = {
    enable = true;
    llmnr = "false";
    dnsovertls = "opportunistic"; # use dns over tls if available
    fallbackDns = lib.mkForce [ ]; # prevents split dns with vpn, so we don't want this
  };
}