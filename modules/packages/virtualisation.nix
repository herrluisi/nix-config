{ pkgs, ... }:
{
  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
    waydroid.enable = true;
  };

  programs.virt-manager.enable = true;

  users.users.uisl.extraGroups = [ "libvirtd" ];
}