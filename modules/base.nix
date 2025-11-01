{
  imports = [
    ./localisation.nix
    ./user.nix
    ./nix
    ./boot
    ./network
    ./packages
  ];

  virtualisation.docker.enable = true;
  virtualisation.waydroid.enable = true;
}
