{
  config,
  lib,
  pkgs,
  ...
}: {
  options.cute.services.media.navidrome = lib.mkEnableOption "";
  config = lib.mkIf config.cute.services.media.navidrome {
    age.secrets.navi-fm.file = ../../../misc/secrets/navi-fm.age;
    services = {
      navidrome = {
        enable = true;
        openFirewall = true;
        settings = {
          Address = "0.0.0.0";
          Port = 8098;
          DataFolder = "/var/lib/navidrome";
          MusicFolder = "/storage/services/navidrome/music";
          ArtistArtPriority = "artist.*, album/artist.*";
          CoverArtPriority = "cover.*, external";
          CoverJpegQuality = 100;
          ImageCacheSize = "0";
          AutoImportPlaylists = false;
          EnableMediaFileCoverArt = false;
          EnableSharing = true;
          EnableStarRating = false;
          EnableTranscodingConfig = true;
          SessionTimeout = "96h";
          UIWelcomeMessage = "";
          LastFM = {
            ApiKey = "9bb677319d28788826b28537483ab363";
            Secret = config.age.secrets.navi-fm.path;
          };
        };
      };
      nginx.virtualHosts."navi.${config.networking.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://127.0.0.1:8098";
      };
    };
    environment.systemPackages = [pkgs.flac];
  };
}