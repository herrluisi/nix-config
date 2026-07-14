{ libF, config, pkgs, ... }:
{
  imports =
    map
      (
        identifier:
        (libF.mkNmWifi {
          inherit config;
          wifiIdentifier = "wifi-${identifier}";
          wifiSsidSops = "wifi/${identifier}/ssid";
          wifiPskSops = "wifi/${identifier}/psk";
        })
      )
      [
        "hotspot"
        "zuhause"
        "laila"
        #"luca_wlan"
        #"tankstelle"
      ];
  networking.hostId = "33565494";

  # VPN Configuration
  networking.firewall.checkReversePath = false;
  environment.systemPackages = with pkgs; [
    wireguard-tools
    protonvpn-gui
  ];
}
