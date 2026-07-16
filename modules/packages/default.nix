{ pkgs, ... }:
{
  imports = [
    ./audio.nix
    ./android.nix
    ./documentation.nix
    ./power.nix
    ./sway.nix
    ./virtualisation.nix
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
    fastfetch
    dig
    nmap
    xkill
    btop
    ripgrep 
    
    parallel

    e2fsprogs # mkfs

    usbutils
    pciutils
    lshw

    unzip
    rclone

    wget
    curl
    whois
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
