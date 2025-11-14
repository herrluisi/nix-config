{ pkgs, ... }:
{
  home.packages = with pkgs; [
    prismlauncher-unwrapped
    lunar-client
    lutris
    steam
  ];
}
