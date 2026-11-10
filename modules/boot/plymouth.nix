{ pkgs, ... }:
{
  boot = {
    plymouth = {
      enable = true;
      logo = pkgs.runCommand "create-transparent-logo" { } ''
        ${pkgs.imagemagick}/bin/convert -size 128x32 xc:transparent tmp.png
        mv tmp.png $out
      '';
    };
  };
}
