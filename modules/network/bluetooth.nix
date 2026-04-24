{ pkgs, ...}:
{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  packages = with pkgs; [
    bluetui
  ];
}
