{
  config,
  lib,
  ...
}: {
  options.cute.services.web.nginx = lib.mkEnableOption "";
  config = let
    inherit (config.networking) domain;
  in
    lib.mkIf config.cute.services.web.nginx {
      networking.firewall.allowedTCPPorts = [80 443];
      security.acme = {
        acceptTerms = true;
        defaults.email = "amce@${domain}";
      };
      services.nginx = {
        enable = true;
        recommendedBrotliSettings = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
        recommendedZstdSettings = true;
        commonHttpConfig = ''
          real_ip_header CF-Connecting-IP;
          add_header 'Referrer-Policy' 'origin-when-cross-origin';
        '';
        virtualHosts."${domain}" = {
          forceSSL = true;
          enableACME = true;
          root = "/storage/website/cafe";
        };
      };
      users.users.nginx.extraGroups = ["acme"];
    };
}