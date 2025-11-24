{ pkgs, ... }:
{
  home.packages = with pkgs; [
    xournalpp
    drawio
    kdePackages.kdeconnect-kde
    obsidian
    drawing
    yed
    gnome-text-editor
    ocrmypdf
    tesseract4 # for ocrmypdf
  ];
}
