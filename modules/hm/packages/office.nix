{ pkgs, nixpkgs-stable, ... }:
{
  home.packages =
    with pkgs;
    [
      texstudio
      nextcloud-client
      nemo-with-extensions
      rclone
      (yazi.override {
		    _7zz = _7zz-rar;  # Support for RAR extraction
	    })
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
