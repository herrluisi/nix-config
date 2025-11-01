{ pkgs, ... }:
{
  services.pulseaudio.enable = false;

  environment.systemPackages = with pkgs; [ alsa-utils ];

  services = {
    pipewire = {
      enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };

      pulse.enable = true;
      jack.enable = true;
    };
  };
}
