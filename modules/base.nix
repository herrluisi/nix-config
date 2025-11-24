{
  imports = [
    ./localisation.nix
    ./user.nix
    ./nix
    ./boot
    ./network
    ./packages
  ];

  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
  };
}
