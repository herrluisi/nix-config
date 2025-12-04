{ pkgs, ... }:
{
  imports = [
    ./audio.nix
    ./kde.nix
    ./android.nix
    ./documentation.nix
    ./sway.nix
  ];

  environment.systemPackages = with pkgs; [
    home-manager
    fhs

    git
    tree
    file
    killall
    openssl
    fd
    neofetch
    dig
    nmap
    xorg.xkill
    btop

    e2fsprogs # mkfs

    usbutils
    pciutils
    lshw

    unzip
    rclone

    wget
    curl
    whois
    dnsutils

    # KDE needed packages
    kdePackages.kcmutils
    kdePackages.qtwebengine
    libsForQt5.kdbusaddons

    # For flameshot working under KDE
    xdg-desktop-portal
  ];

  # File Manager and dconf for all apps
  services = {
    gvfs.enable = true;
    devmon.enable = true;
  };

  programs.dconf.enable = true;

  environment.sessionVariables = rec {
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XCURSOR_SIZE = "24";
  };
}
