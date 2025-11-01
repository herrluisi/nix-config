{ pkgs, pkgs-2505, ... }:
{
  home.packages =
    with pkgs;
    [
      texstudio
      nextcloud-client
      nemo-with-extensions

      hunspell
    ]
    ++ (with pkgs.hunspellDicts; [
      en_US
      de_DE
    ])
    ++ (with pkgs-2505; [
      texlive.combined.scheme-full
    ]);
}
