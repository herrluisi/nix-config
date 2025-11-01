{ pkgs, ... }:
{
  home.file.".config/autostart/element-desktop.desktop" = {
    source = "${pkgs.element-desktop}/share/applications/element-desktop.desktop";
  };

  # To start signal minimized in tray go to File -> Preferences -> General -> System
  # and select Start minized in tray and Minimize to system tray.
  # This setting cannot be made declarative because it's stored with other dynamic
  # settings e.g. the window position in ~/.config/Signal/ephemeral.json
  # TODO doesn't work since 05/2025
  home.file.".config/autostart/signal-desktop.desktop" = {
    source = "${pkgs.signal-desktop}/share/applications/signal-desktop.desktop";
  };

  home.file.".config/autostart/thunderbird.desktop" = {
    source = "${pkgs.thunderbird}/share/applications/thunderbird.desktop";
  };

  services.syncthing.enable = true;
  systemd.user.startServices = true;
}
