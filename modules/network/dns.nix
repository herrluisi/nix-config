{ lib, ... }:
{
  networking.nameservers = [ "1.1.1.1" ];
  services.resolved = {
    enable = true;
    settings.Resolve = {
      LLMNR = "false";
      DNSOverTLS = "opportunistic"; # use dns over tls if available
      FallbackDNS = lib.mkForce [ ]; # prevents split dns with vpn, so we don't want this
    };
  };
}
