{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;

      userName = "Luis Herr";
      userEmail = "kontakt@luisherr.eu";

      signing = {
        key = "8A07C1FC53085B285661AF54F2C298803429EA24";
        signByDefault = true;
      };

      extraConfig = {
        push.autoSetupRemote = true;
        init.defaultBranch = "main";
      };
    };
  };

  home.packages = with pkgs; [
    gh
  ];
}
