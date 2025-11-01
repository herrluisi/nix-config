{
  imports = [
    # Essential tools
    ./modules/hm/bash.nix
    ./modules/hm/git.nix
    ./modules/hm/gpg.nix
    ./modules/hm/mail.nix

    # Desktop environment
    ./modules/hm/desktop/mimetypes.nix
    ./modules/hm/desktop/autostart.nix

    ./modules/hm/packages/default.nix

    # Software configuration
    ./modules/hm/browser.nix

  ];

  home.username = "uisl";
  home.homeDirectory = "/home/uisl";

  home.file.".face" = {
    source = builtins.fetchurl {
      url = "https://avatars.githubusercontent.com/herrluisi";
      sha256 = "sha256:03l71lg555lya7mbjv7c3411gz874mlbd82ns2l32k68lji9n8rm";
    };
  };

  home.file.".nanorc" = {
    text = ''
      set tabstospaces
      set tabsize 2
    '';
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  programs.home-manager.enable = true;
}
