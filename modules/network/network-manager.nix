{ pkgs, ... }:
{
  networking = {
    networkmanager = {
      enable = true;
      # ethernet.macAddress = "random";
      # wifi.macAddress = "random";
    };
  };

  environment.systemPackages = with pkgs; [
    pkgs.networkmanagerapplet # nm-connection-editor
    networkmanager-openvpn
  ];

  users.users.uisl.extraGroups = [ "networkmanager" ];
}
