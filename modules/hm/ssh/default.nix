{ lib, ... }:
{
  imports = [
    ./config/common.nix
    ./config/felbinger.nix
    ./config/secshell.nix
    ./config/as203218.nix
    ./config/helpwave.nix
  ];

  programs.ssh = {
    enable = true;
    serverAliveInterval = 20;
    controlMaster = "auto";
    controlPersist = "2h";
    extraConfig = ''
      TCPKeepAlive no
      #VerifyHostKeyDNS yes
      #Host no-key-support
      #  PasswordAuthentication yes
      #  PreferredAuthentications=keyboard-interactive,password
      #  PubkeyAuthentication no

      #Host ignore-host-keys
      #  StrictHostKeyChecking no
      #  UserKnownHostsFile /dev/null
      #  LogLevel QUIET

      #Host via-v6-link-local
      #  Hostname fe80::1893:7dff:fe38:0e1e%%eth2
      #  ProxyJump router
    '';
    includes = [
      "~/.ssh/tmp_config" # file can be manually created by the user on demand
    ];
    userKnownHostsFile = lib.concatStringsSep " " [
      "~/.ssh/known_hosts" # this has to be the first file, to which by default new keys are being written
      ./known_hosts/common
      ./known_hosts/secshell
      ./known_hosts/as203218
      ./known_hosts/helpwave
      ./known_hosts/felbinger
      ./known_hosts/ffvec
    ];
  };

  home.file.".ssh/yubikey.pub" = {
    source = builtins.fetchurl {
      url = "https://github.com/felbinger.keys";
      sha256 = "sha256:1pbvwr1jbnxjrlj0f3q7cvscb88y9pbpa09q01yini4vwnczw6hi";
    };
  };
}
