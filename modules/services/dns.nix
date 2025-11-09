# Systemd Service for adding the dns server to the config
{
  systemd.services.add-dns-server = {
    script = ''
      echo nameserver 1.1.1.1 | tee /etc/resolv.conf
    '';

    # This service runs once and finishes,
    # instead of the default long-live services
    type = "oneshot";

    # "Enable" the service
    wantedBy = [ "multi-user.target" ];
  };
}