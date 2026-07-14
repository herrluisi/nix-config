{
  imports = [
    ./plymouth.nix
    ./silent-boot.nix
    ./systemd-boot.nix
    ./logind.nix
  ];

  boot = {
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };

    # cross build aarch64 (e. g. for raspberry pi)
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
