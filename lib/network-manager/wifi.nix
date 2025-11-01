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
let
  # Use name to generate string in uuid format (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)
  mkUuid =
    name:
    let
      hash = builtins.hashString "md5" name;
    in
    builtins.substring 0 8 hash
    + "-"
    + builtins.substring 8 4 hash
    + "-"
    + builtins.substring 12 4 hash
    + "-"
    + builtins.substring 16 4 hash
    + "-"
    + builtins.substring 20 12 hash;
in
{
  # TODO migrate to nix module: networking.networkmanager.ensureProfiles.profiles."${wifiIdentifier}"
  sops = {
    secrets = {
      "${wifiSsidSops}".sopsFile = ../../wifi-secrets.yaml;
      "${wifiPskSops}".sopsFile = ../../wifi-secrets.yaml;
    };
    templates."network-manager/${wifiIdentifier}.nmconnection" = {
      path = "/etc/NetworkManager/system-connections/${wifiIdentifier}.nmconnection";
      content = ''
        [connection]
        id=${config.sops.placeholder."${wifiSsidSops}"}
        uuid=${mkUuid wifiIdentifier}
        type=wifi

        [wifi]
        mode=infrastructure
        ssid=${config.sops.placeholder."${wifiSsidSops}"}

        [wifi-security]
        auth-alg=open
        key-mgmt=wpa-psk
        psk=${config.sops.placeholder."${wifiPskSops}"}

        [ipv4]
        method=auto

        [ipv6]
        addr-gen-mode=default
        method=auto

        [proxy]
      '';
    };
  };
}
