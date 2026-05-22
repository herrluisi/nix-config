{
  # Aktiviert den Fingerabdruck-Hintergrunddienst (fprintd)
  services.fprintd.enable = true;

  # Wichtig für Sway: Schaltet das System-PAM für swaylock frei
  security.pam.services = {
    swaylock.text = ''
      auth      sufficient  pam_fprintd.so
      auth      include     login
    '';

    sudo.fprintAuth = true;
  };
}
