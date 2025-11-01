{ pkgs, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    cudatoolkit
    vulkan-tools
    vulkan-loader
  ];

  hardware.nvidia.open = false; # gtx 1060 is not supported by open driver
}
