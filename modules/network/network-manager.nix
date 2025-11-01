{ pkgs, ... }:
{
  networking = {
    networkmanager = {
      enable = true;
      # ethernet.macAddress = "random";
      # wifi.macAddress = "random";
      dns = "systemd-resolved";
    };
  };

  # nm-connection-editor
  environment.systemPackages = with pkgs; [ 
    pkgs.networkmanagerapplet
    networkmanager-openvpn
  ];

  users.users.uisl.extraGroups = [ "networkmanager" ];
}
