{
  imports = [
    ./localisation.nix
    ./user.nix
    ./graphics.nix
    ./nix
    ./boot
    ./network
    ./packages
  ];

  home-manager.backupFileExtension = ".nixbak";
}
