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
  environment.systemPackages = [ pkgs.networkmanagerapplet ];

  users.users.uisl.extraGroups = [ "networkmanager" ];
}
