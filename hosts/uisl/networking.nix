{
  libF,
  config,
  ...
}:
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
      ];
}
