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
  mailbox = {
    userName = "herrluisi@mailbox.org";
    imap = {
      host = "imap.mailbox.org";
      port = 993;
      tls.enable = true;
    };
    smtp = {
      host = "smtp.mailbox.org";
      port = 465;
      tls.enable = true;
    };
  };
  thm = {
    userName = "lmhr13";
    imap = {
      host = "mailgate.thm.de";
      port = 993;
      tls.enable = true;
    };
    smtp = {
      host = "mailgate.thm.de";
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
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
      withExternalGnupg = true;
    };
  };

  accounts.email.accounts = {
    "herrluisi@mailbox.org" = {
      primary = true;
      address = "herrluisi@mailbox.org";
      aliases = [
        "kontakt@luisherr.eu"
        "drk@luisherr.eu"
        "politik@luisherr.eu"
      ];
      inherit (mailbox) imap smtp userName;
      inherit signature realName;
      thunderbird.enable = true;
    };
    "luis.maximilian.herr@gmail.com" = {
      address = "luis.maximilian.herr@gmail.com";
      userName = "luis.maximilian.herr@gmail.com";
      inherit (gmail) imap smtp;
      inherit signature realName;
      thunderbird.enable = true;
    };
    "luis.herr@zdh.thm.de" = {
      address = "luis.herr@zdh.thm.de";
      inherit (thm) imap smtp userName;
      inherit signature realName;
      thunderbird.enable = true;
    };
  };
}
