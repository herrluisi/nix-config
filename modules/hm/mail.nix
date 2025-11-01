{
  ...
}:
{
  accounts.email.accounts = {
    "kontakt@luisherr.de" = {
      primary = true;
      address = "kontakt@luisherr.de";
      realName = "Luis Herr";
      userName = "kontakt@luisherr.de";
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
      signature = {
        showSignature = "append";
        text = ''
          Mit freundlichen Grüßen
          Luis Herr
        '';
      };
      thunderbird.enable = true;
    };
    "politik@luisherr.de" = {
      address = "politik@luisherr.de";
      realName = "Luis Herr";
      userName = "politik@luisherr.de";
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
      signature = {
        showSignature = "append";
        text = ''
          Mit freundlichen Grüßen
          Luis Herr
        '';
      };
      thunderbird.enable = true;
    };
  };
}
