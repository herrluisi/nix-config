{
  config,
  ## WiFi Configuration
  wifiIdentifier,
  # The ssid of the wireless network
  wifiSsidSops,
  # The sops path to the pre shared key
  wifiPskSops,
  ...
}:
{
  sops.secrets = {
    "${wifiSsidSops}".sopsFile = ../../wifi-secrets.yaml;
    "${wifiPskSops}".sopsFile = ../../wifi-secrets.yaml;
  };

  networking.networkmanager.ensureProfiles = {
    secrets = {
      entries = [
        {
          matchId = wifiIdentifier;
          matchType = "connection";
          matchSetting = "802-11-wireless";
          key = "ssid";
          file = config.sops.secrets."${wifiSsidSops}".path;
        }
        {
          matchId = wifiIdentifier;
          matchType = "connection";
          matchSetting = "802-11-wireless-security";
          key = "psk";
          file = config.sops.secrets."${wifiPskSops}".path;
        }
      ];
    };
    profiles."${wifiIdentifier}" = {
      connection = {
        id = wifiIdentifier;
        type = "wifi";
      };
      wifi = {
        mode = "infrastructure";
      };
      wifi-security = {
        auth-alg = "open";
        key-mgmt = "wpa-psk";
      };
      ipv4 = {
        method = "auto";
      };
      ipv6 = {
        method = "auto";
        addr-gen-mode = "default";
      };
    };
  };
}
