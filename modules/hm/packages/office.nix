{ pkgs, nixpkgs-stable, ... }:
{
  home.packages =
    with pkgs;
    [
      texstudio
      nextcloud-client
      nemo-with-extensions

      thunderbird

      hunspell
    ]
    ++ (with pkgs.hunspellDicts; [
      en_US
      de_DE
    ])
    ++ (with nixpkgs-stable; [
      texlive.combined.scheme-full
    ]);
}
