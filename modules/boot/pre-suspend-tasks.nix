{ pkgs, ... }:
{
  systemd.services."pre-suspend-command" = {
    description = "Lock screen before suspend";
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];
    unitConfig = {
      StopWhenUnneeded = true;
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -lc 'swaylock -Ki /home/uisl/Documents/my_stuff/picture_of_the_day/latest.jpg'";
    };
  };
}
