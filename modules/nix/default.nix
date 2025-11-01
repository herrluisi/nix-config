{
  pkgs,
  ...
}:
{
  imports = [
    ./activation-diff.nix
  ];

  nix = {
    optimise.automatic = true;

    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    package = pkgs.nixVersions.latest;

    channel.enable = false; # remove nix-channel related tools & configs

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };

    settings = {
      trusted-users = [ "@wheel" ];
    };
  };
}
