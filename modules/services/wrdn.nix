{
  config,
  lib,
  ...
}: {
  options.cute.services.wrdn = lib.mkEnableOption "";
  config = let
    inherit (config.networking) domain;
  in
    lib.mkIf config.cute.services.wrdn {
      services = {
        vaultwarden = {
          enable = true;
          config = {
            DOMAIN = "https://vault.pagu.cafe";
            SIGNUPS_ALLOWED = true;
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = 8222;
          };
          backupDir = "/storage/services/vaultwarden";
        };
        nginx.virtualHosts."wrdn.${domain}" = {
          forceSSL = true;
          enableACME = true;
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
            extraConfig = "proxy_pass_header Authorization;";
          };
        };
      };
    };
}
