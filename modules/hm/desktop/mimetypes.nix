let
  config = {
    "inode/directory" = [ "nemo.desktop" ];

    "application/pdf" = [ "org.gnome.Evince.desktop" ];

    "x-scheme-handler/mailto" = [ "userapp-Evolution-TMK4D2.desktop" ];

    #"x-scheme-handler/jetbrains" = [ "jetbrains-toolbox.desktop" ];
    #"x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
    "x-scheme-handler/magnet" = [ "userapp-transmission-gtk-UPU6O2.desktop" ];

    "image/png" = [ "org.gnome.Loupe.desktop" ];
    "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
    "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];

    "video/mp4" = [ "vlc.desktop" ];
    "video/x-matroska" = [ "vlc.desktop" ];
    "audio/aac" = [ "vlc.desktop" ];

    "text/markdown" = [ "xed.desktop" ];
    "text/plain" = [ "xed.desktop" ];
    "text/xml" = [ "xed.desktop" ];
    "application/octet-stream" = [ "xed.desktop" ];
    "application/x-shellscript" = [ "xed.desktop" ];

    "text/x-tex" = [ "userapp-codium-X5T6S2.desktop" ];

    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
    "x-scheme-handler/chrome" = [ "firefox.desktop" ];
    "text/html" = [ "firefox.desktop" ];
    "application/x-extension-htm" = [ "firefox.desktop" ];
    "application/x-extension-html" = [ "firefox.desktop" ];
    "application/x-extension-shtml" = [ "firefox.desktop" ];
    "application/xhtml+xml" = [ "firefox.desktop" ];
    "application/x-extension-xhtml" = [ "firefox.desktop" ];
    "application/x-extension-xht" = [ "firefox.desktop" ];
  };
in
{
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = config;
      defaultApplications = config;
    };
  };
}
