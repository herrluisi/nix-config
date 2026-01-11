{
  imports = [
    ./localisation.nix
    ./user.nix
    ./nix
    ./boot
    ./network
    ./packages
  ];

  home-manager.backupFileExtension = ".nixbak";
}
