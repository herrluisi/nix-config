{
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      editor = false; # disable systemd-boot edit cmdline
      configurationLimit = 10;
    };
  };
}
