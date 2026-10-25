{ pkgs, ... }:

{
  # 1. Libvirt & QEMU Konfiguration bereinigen
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      # HIER ENTFERNT: spiceUSBRedirection.enable = true; (gibt es hier nicht)
    };
  };

  # 2. SPICE USB-Redirection korrekt auf Host-Ebene aktivieren (falls gewünscht)
  virtualisation.spiceUSBRedirection.enable = true;

  # 3. Virt-Manager & benötigte Host-Tools
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    opentofu
    virt-viewer
    cdrkit
    spice-gtk          # Notwendig für USB-Weiterleitung in SPICE-Clients
  ];

  # 4. Berechtigungen
  users.users.uisl.extraGroups = [ "libvirtd" "kvm" ];
}
