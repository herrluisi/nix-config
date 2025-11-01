{ ... }:
{
  programs.adb.enable = true;
  users.users.uisl.extraGroups = [ "adbusers" ];
}
