{
  imports = [
    ./graphics.nix
    ./localisation.nix
    ./systemd-timers.nix
    ./user.nix
    ./virtualisation.nix
    ./nix
    ./boot
    ./network
    ./packages
  ];

  home-manager.backupFileExtension = ".nixbak";

  # disables openldap checks to use lutris. OpenLDAP checks are weird at the building stage from the system.
  nixpkgs.overlays = [
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];
}
