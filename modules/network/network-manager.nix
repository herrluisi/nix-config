{ pkgs, ... }:
{
  networking = {
    networkmanager = {
      enable = true;
    };
    wireless.iwd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pkgs.networkmanagerapplet # nm-connection-editor
    networkmanager-openvpn
  ];

  users.users.uisl.extraGroups = [ "networkmanager" ];
}
