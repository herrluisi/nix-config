{
  programs.chromium = {
    enable = true;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "gcknhkkoolaabfmlnjonogaaifnjlfnp"; } # Foxy Proxy
      { id = "dhdgffkkebhmkfjojejmpbldmpobfkfo"; } # Tampermonkey
      { id = "gppongmhjkpfnbhagpmjfkannfbllamg"; } # Wappalyzer
      { id = "pfdhoblngboilpfeibdedpjgfnlcodoo"; } # Simple Websocket Client
      { id = "djflhoibgkdhkhhcedjiklpkjnoahfmg"; } # User-Agent Switcher
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
      { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } # Privacy Badger
    ];
    package = pkgs.vivaldi;
  };

  programs.firefox = {
    enable = true;
    policies = {
      # see https://github.com/mozilla/policy-templates/blob/master/linux/policies.json
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;

      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "always";

      Homepage = {
        URL = "chrome://browser/content/blanktab.html";
        StartPage = "homepage";
      };

      # Check about:support for extension/add-on ID strings.
      ExtensionSettings = {
        "*".installation_mode = "blocked";
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Dark Reader
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
        };
        # Flash and Video Downloader
        "{adeadebb-fedc-4180-a7f4-cfdd87496551}" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/download-video-and-flash/latest.xpi";
          installation_mode = "force_installed";
        };
        # FoxyProxy
        "foxyproxy@eric.h.jung" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/foxyproxy-standard/latest.xpi";
          installation_mode = "force_installed";
        };
        # Privacy Badger
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };
        # Wappalyzer
        "wappalyzer@crunchlabz.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/wappalyzer/latest.xpi";
          installation_mode = "force_installed";
        };
        # Tamper Data
        "{2bd18ca8-5dd7-4311-a777-02ed29663496}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tamper-data-for-ff-quantum/latest.xpi";
          installation_mode = "force_installed";
        };
        # Skip Redirect
        "skipredirect@sblask" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/skip-redirect/latest.xpi";
          installation_mode = "force_installed";
        };
        # User-Agent Switcher
        "{75afe46a-7a50-4c6b-b866-c43a1075b071}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/user-agent-switcher-revived/latest.xpi";
          installation_mode = "force_installed";
        };
        # HackTools
        "{f1423c11-a4e2-4709-a0f8-6d6a68c83d08}" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/hacktools/latest.xpi";
          installation_mode = "force_installed";
        };
        # Bitwarden
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
        # Silk - Privacy Pass Client
        "{48748554-4c01-49e8-94af-79662bf34d50}" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/privacy-pass/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };

    profiles = {
      default = {
        settings = {
          "browser.shell.checkDefaultBrowser" = false;
          "browser.uiCustomization.state" =
            ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":[],"nav-bar":["back-button","forward-button","stop-reload-button","home-button","urlbar-container","search-container","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action","reset-pbm-toolbar-button","addon_darkreader_org-browser-action","foxyproxy_eric_h_jung-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action","_adeadebb-fedc-4180-a7f4-cfdd87496551_-browser-action","unified-extensions-button","downloads-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button"],"PersonalToolbar":["personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","ublock0_raymondhill_net-browser-action","_testpilot-containers-browser-action","_adeadebb-fedc-4180-a7f4-cfdd87496551_-browser-action","foxyproxy_eric_h_jung-browser-action","addon_darkreader_org-browser-action","jid1-mnnxcxisbpnsxq_jetpack-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list","unified-extensions-area"],"currentVersion":20,"newElementCount":7}'';
          "dom.security.https_only_mode" = true;
          "privacy.trackingprotection.enabled" = true;
          "identity.fxaccounts.enabled" = false;
        };
        bookmarks = {
          force = true;
          settings = [
            {
              name = "Bookmarks Toolbar";
              toolbar = true;
              bookmarks = [
                {
                  name = "IT";
                  bookmarks = [
                    {
                      name = "Organisation";
                      bookmarks = [
                        {
                          name = "BNetzA Verzeichnis gemeldeter ISP";
                          url = "https://www.bundesnetzagentur.de/DE/Fachthemen/Telekommunikation/Unternehmenspflichten/Meldepflicht/start.html";
                        }
                      ];
                    }
                  ];
                }
              ];
            }
          ];
        };
      };
    };
  };
}
