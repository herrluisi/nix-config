{ pkgs, ... }:
{
  imports = [
    ./audio.nix
    ./kde.nix
    ./android.nix
    ./documentation.nix
  ];

  environment.systemPackages = with pkgs; [
    home-manager

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

  ];

  # File Manager and dconf for all apps
  services = {
    gvfs.enable = true;
    devmon.enable = true;
  };
  programs.dconf.enable = true;
}
