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

    e2fsprogs # mkfs

    usbutils
    pciutils
    lshw

    unzip

    wget
    curl
    whois
    dnsutils
  ];
}
