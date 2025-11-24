let
  gmail = {
    imap = {
      host = "imap.gmail.com";
      port = 993;
      tls.enable = true;
    };
    smtp = {
      host = "smtp.gmail.com";
      port = 465;
      tls.enable = true;
    };
  };
  felbinger = {
    imap = {
      host = "mail.felbinger.eu";
      port = 993;
      tls.enable = true;
    };
    smtp = {
      host = "mail.felbinger.eu";
      port = 465;
      tls.enable = true;
    };
  };
  realName = "Luis Herr";
  signature = {
    showSignature = "append";
    text = ''
      Mit freundlichen Grüßen
      Luis Herr
    '';
  };
in
{
  sops.secrets.hugob_mail_pass.sopsFile = ./secrets.yaml;



  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      withExternalGnupg = true;
    };
  };

  accounts.email.accounts = {
    "kontakt@luisherr.de" = {
      primary = true;
      address = "kontakt@luisherr.de";
      userName = address;
      inherit (felbinger) imap smtp;
      inherit signature realName;
      thunderbird.enable = true;
    };
    "politik@luisherr.de" = {
      address = "politik@luisherr.de";
      userName = address;
      inherit (felbinger) imap smtp;
      inherit signature realName;
      thunderbird.enable = true;
    };
    "luis.maximilian.herr@gmail.com" = {
      address = "luis.maximilian.herr@gmail.com";
      userName = address;
      inherit (gmail) imap smtp;
      inherit signature realName;
      thunderbird.enable = true;
    };
    "amphomoronal@gmail.com" = {
      address = "amphomoronal@gmail.com";
      userName = address;
      inherit (gmail) imap smtp;
      inherit signature realName;
      thunderbird.enable = true;
    };
    "luis@novacodes.eu" = {
      address = "luis@novacodes.eu";
      userName = "luis@novacodes.eu";
      inherit (felbinger) imap smtp;
      inherit signature realName;
      thunderbird.enable = true;
    };
  };
}

      passwordCommand = "cat ${config.sops.secrets.hugob_mail_pass.path}";
