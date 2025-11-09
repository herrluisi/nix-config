{
  imports = [
    ./localisation.nix
    ./user.nix
    ./nix
    ./boot
    ./network
    ./packages
    ./services
  ];

  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
  };
}
