{ pkgs, lib, ... }:
let
  # see https://github.com/flameshot-org/flameshot/issues/3365#issuecomment-1868580715
  flameshot-gui = pkgs.writeShellScriptBin "flameshot-gui" "${lib.getExe pkgs.flameshot} gui";
in
{
  home.sessionVariables = {
    GTK_THEME = "Adwaita-dark";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
      clock-show-weekday = true;
      clock-show-seconds = true;
      show-battery-percentage = true;
    };
    "org/gnome/desktop/datetime" = {
      automatic-timezone = true;
    };
    "org/gnome/desktop/calendar" = {
      show-weekdate = true;
    };
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "terminator";
      exec-arg = "";
    };
    "org/cinnamon/desktop/applications/terminal" = {
      # required for nemo (right click -> open in terminal)
      exec = "terminator";
    };
    "org/nemo/window-state" = {
      sidebar-bookmark-breakpoint = 3; # local bookmarks to "My computer", remaining to "bookmarks"
    };
    # remove open as root from context menu
    "org/nemo/preferences/menu-config" = {
      background-menu-open-as-root = true;
      selection-menu-open-as-root = true;
    };
    "org/nemo/preferences" = {
      #context-menus-show-all-actions = true;
      desktop-is-home-dir = true;
      default-folder-viewer = "list-view";
      show-full-path-titles = true;
      show-location-entry = true;
      show-compact-view-icon-toolbar = false;
      show-edit-icon-toolbar = false;
      show-icon-view-icon-toolbar = false;
      show-list-view-icon-toolbar = false;
      show-show-thumbnails-toolbar = false;
      executable-text-activation = "display";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      natural-scroll = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        #"trayIconsReloaded@selfmade.pl"
        "appindicatorsupport@rgcjonas.gmail.com"
        "just-perfection-desktop@just-perfection"
      ];
      favorite-apps = [ "firefox.desktop" ];
    };
    "org/gnome/shell/extensions/trayIconsReloaded" = {
      icon-padding-horizontal = 0;
      icon-margin-horizontal = 4;
      icons-limit = 8;
    };
    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-type = "nothing";
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      help = [ "" ];
      home = [ "<Super>e" ];
      show-screen-recording-ui = [ "" ];
      show-screenshot-ui = [ "" ];
      screenshot = [ "" ];
      screenshot-window = [ "" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Terminal";
      command = "${pkgs.terminator}/bin/terminator";
      binding = "<Control><Alt>t";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Snapshot";
      command = lib.getExe flameshot-gui;
      binding = "<Shift><Control>s";
    };
    "org/gnome/shell/keybindings" = {
      screenshot = "@as []";
      screenshot-window = "@as []";
      show-screenshot-ui = "@as []";
      show-screen-recording-ui = "@as []";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${pkgs.gnome-backgrounds}/gnome/vnc-l.png";
      picture-uri-dark = "file://${pkgs.gnome-backgrounds}/gnome/vnc-d.png";
      picture-options = "zoom";
      primary-color = "#150936";
      color-shading-type = "solid";
      show-desktop-icons = false;
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file://${pkgs.gnome-backgrounds}/gnome/vnc-d.png";
      primary-color = "#150936";
    };
    "org/gnome/shell/extensions/just-perfection" = {
      activities-button = false;
      world-clock = false;
      weather = false;
      window-menu-take-screenshot-button = false;
      startup-status = 0;
    };
    "org/gnome/desktop/sound" = {
      theme-name = "__custom"; # disable screenshot sound effect
    };
    "org/gnome/mutter" = {
      workspaces-only-on-primary = false;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3 = {
      bookmarks = [
        "file:///home/nicof2000/Documents"
        "file:///home/nicof2000/Downloads"
        "file:///home/nicof2000/Projects"
        "sftp://nas.julian.secshell.net/home/nicof2000 nas"
        "sftp://hm90.parents.felbinger.eu/home/nicof2000 hm90"
      ];
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "Adwaita-dark";
    style = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  home.file.".local/share/sounds/__custom/screen-capture.disabled".text = "";

  services = {
    gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };
  };

  home.packages = with pkgs.gnomeExtensions; [
    appindicator
    #tray-icons-reloaded
    just-perfection
  ];
}
