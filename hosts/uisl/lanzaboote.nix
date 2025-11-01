{
  pkgs,
  config,
  lib,
  ...
}:
{
  environment.systemPackages = [ pkgs.sbctl ];
  boot = {
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  # lanzaboote: write secureboote keys to locations
  sops.secrets = lib.listToAttrs (
    builtins.concatMap
      (
        x:
        map
          (y: {
            name = "lanzaboote/${x}/${y}";
            value.path = "${config.boot.lanzaboote.pkiBundle}/keys/${x}/${x}.${y}";
          })
          [
            "key"
            "pem"
          ]
      )
      [
        "db"
        "KEK"
        "PK"
      ]
  );
}
