{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cute.services.storage.nextcloud = lib.mkEnableOption "";
  config = let
    inherit (config.networking) domain;
  in
    lib.mkIf config.cute.services.storage.nextcloud {
      age.secrets = {
        nextcloud = {
          file = ../../../misc/secrets/nextcloud.age;
          owner = "nextcloud";
        };
      };
      services = {
        nextcloud = {
          enable = true;
          package = pkgs.nextcloud28;
          home = "/storage/services/nextcloud";
          configureRedis = true;
          database.createLocally = true;
          config = {
            adminuser = "pagu";
            adminpassFile = config.age.secrets.nextcloud.path; # setup only
            dbtype = "pgsql";
          };
          phpOptions = {
            "opcache.interned_strings_buffer" = "16";
            "output_buffering" = "off";
          };
          settings = {
            default_phone_region = "NZ";
            overwriteprotocol = "https";
            trusted_proxies = ["https://next.${domain}"];
            trusted_domains = ["https://next.${domain}"];
            mail_smtpmode = "smtp";
            mail_sendmailmode = "smtp";
            mail_smtpsecure = "ssl";
            mail_smtphost = "mail.${domain}";
            mail_smtpport = "465";
            mail_smtpauth = 1;
            mail_smtpname = "nextcloud@${domain}";
            mail_from_address = "nextcloud";
            mail_domain = domain;
          };
          hostName = "next.${domain}";
          https = true;
          nginx.recommendedHttpHeaders = true;
        };
        nginx.virtualHosts."next.${domain}" = {
          forceSSL = true;
          enableACME = true;
          http2 = true;
        };
      };
    };
}