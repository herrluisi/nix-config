{ config, pkgs, ... }:

{
  sops.secrets.nasa_key = {
    format = "yaml";
  };

  ### BACKGROUND IMAGE NASA APOD ###
  systemd.user.services.desktop-background = {
    unitConfig = {
      Description = "Sets the background image to the astronomy picture of the day from NASA";
      After = [ "network-online.target" ];
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "curl -s 'https://api.nasa.gov/planetary/apod?api_key=${config.sops.secrets.nasa_key.path}' | jq -r '.hdurl' | xargs curl -L -o /home/uisl/Documents/my_stuff/picture_of_the_day/latest.jpg";
    };
  };

  systemd.user.timers.desktop-background = {
    unitConfig = {
      Description = "Daily timer to set desktop background image from NASA APOD";
    };
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "desktop-background.service";
    };
  };
}