{ inputs, ... }:

{
  services.flatpak.enable = true;

  services.flatpak.packages = [
    {
      appId = "dev.stormix.deadlock-mod-manager";
      bundle = inputs.deadlock-mod-manager.outPath;
      sha256 = inputs.deadlock-mod-manager.narHash;
    }
  ];
}
