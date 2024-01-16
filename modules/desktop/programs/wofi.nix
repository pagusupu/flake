{
  config,
  lib,
  ...
}: {
  options.cute.desktop.programs.wofi.enable = lib.mkEnableOption "";
  config = lib.mkIf config.cute.desktop.programs.wofi.enable {
    home-manager.users.pagu = {
      programs.wofi = {
        enable = true;
        settings = {
          width = "15%";
          height = "30%";
          hide_scroll = true;
          insensitive = true;
          prompt = "";
        };
      };
    };
  };
}