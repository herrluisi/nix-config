{
  imports = [
    # Essential tools
    ./bash.nix
    ./git.nix
    ./gpg.nix
#    ./mail.nix
#    ./sway.nix


    # Desktop environment
    ./desktop

    ./packages

    # Software configuration
    ./browser.nix
  ];
}
