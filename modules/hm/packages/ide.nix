{
  pkgs-2505,
  pkgs,
  lib,
  ...
}:
{
  home.packages =
    with pkgs-2505;
    [
      jetbrains.webstorm
      jetbrains.pycharm-professional
      jetbrains.idea-ultimate
      jetbrains.datagrip
      jetbrains-mono
      jetbrains.rust-rover
      android-studio
    ]
    ++ (with pkgs; [
      marksman # markdown
      yaml-language-server
      nginx-language-server
      bash-language-server
    ]);

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default = {
      userSettings = {
        "editor.tabSize" = 2;
        "editor.unicodeHighlight.nonBasicASCII" = false;
        "files.trimTrailingWhitespace" = true;
        "files.trimFinalNewlines" = true;
        "editor.formatOnSave" = true;
        "editor.defaultFormatter" = null;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${lib.getExe pkgs.nil}";
        "[nix]"."editor.defaultFormatter" = "jnoortheen.nix-ide";
      };
      extensions = with pkgs.vscode-extensions; [
        hediet.vscode-drawio
        bierner.markdown-mermaid
        bbenoist.nix
        jnoortheen.nix-ide
      ];
    };
  };
}
