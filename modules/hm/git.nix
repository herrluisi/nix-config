{ pkgs, ... }:
{
  programs = {
    git = {
      enable = true;

      signing = {
        key = "4790A5119BC18FD4";  # Key from Framework Laptop
        # key = "8A07C1FC53085B285661AF54F2C298803429EA24";  # Key from Acer Nitro 5
        signByDefault = true;
      };

      settings = {
        user = {
          name = "Luis Herr";
          email = "kontakt@luisherr.eu";
        };
        push.autoSetupRemote = true;
        init.defaultBranch = "main";
        safe.directory = "*";
      };
    };
  };

  # For authentication with GitHub
  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };
}
