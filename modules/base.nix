{
  imports = [
    ./localisation.nix
    ./user.nix
    ./graphics.nix
    ./systemd-timers.nix
    ./nix
    ./boot
    ./network
    ./packages
  ];

  home-manager.backupFileExtension = ".nixbak";
}
