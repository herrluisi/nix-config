{ pkgs, ... }:
{
  home.packages = with pkgs; [
    prismlauncher-unwrapped
    lunar-client
    lutris
    wineWowPackages.full
    winetricks
    steam
    vulkan-tools
  ];
}
