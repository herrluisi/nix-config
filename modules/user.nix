{ config, ... }:
{
  sops.secrets = {
    "rootPassword".neededForUsers = true;
    "uislPassword".neededForUsers = true;
  };

  users.users = {
    root = {
      hashedPasswordFile = config.sops.secrets."rootPassword".path;
    };
    uisl = {
      isNormalUser = true;
      home = "/home/uisl";
      description = "Luis Herr"
      uid = 1000;
      extraGroups = [
        "wheel" # sudoer
      ];

      hashedPasswordFile = config.sops.secrets."uislPassword".path;
    };
  };
}
