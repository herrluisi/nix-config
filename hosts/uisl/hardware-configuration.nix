{ config, lib, modulesPath, pkgs, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = { 
      availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "amdgpu" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    zfs.forceImportRoot = false;
    kernelPackages = pkgs.linuxPackages_6_12;
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.fwupd.enable = true;
}
