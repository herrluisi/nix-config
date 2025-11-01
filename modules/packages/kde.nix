{
  # Desktop enviroment
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb.layout = "de";
  services.displayManager.sddm.autoNumlock = true;
  networking.networkmanager.enable = true;


  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
  ];  
  # Audio
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;
  security.rtkit.enable = true;
    services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;
  };

  # File Manager and dconf for all apps
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  programs.dconf.enable = true;


  hardware.bluetooth.enable = true;
  services.blueman.enable = true;  
}
