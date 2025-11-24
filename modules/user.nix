{ config, ... }:
{
  sops.secrets = {
    "rootPassword".neededForUsers = true;
    "uislPassword".neededForUsers = true;
  };

  users.mutableUsers = false;
  users.users = {
    root = {
      hashedPasswordFile = config.sops.secrets."rootPassword".path;
    };
    uisl = {
      isNormalUser = true;
      home = "/home/uisl";
      description = "Luis Herr";
      uid = 1000;
      extraGroups = [
        "wheel" # sudoer
        "video" # for sway
      ];
#      password = "password";
      hashedPasswordFile = config.sops.secrets."uislPassword".path;
    };
  };
}
