{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      texlive.combined.scheme-full

      hunspell
    ]
    ++ (with pkgs.hunspellDicts; [
      en_US
      de_DE
    ]);
}
