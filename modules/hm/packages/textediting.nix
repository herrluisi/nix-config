{ pkgs, ... }:
{
  home.packages = with pkgs; [
    xournalpp
    drawio
    obsidian
    drawing
    yed
    gnome-text-editor
    ocrmypdf
    tesseract4 # for ocrmypdf
  ];
}
