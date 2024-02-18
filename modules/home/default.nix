{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];
  options.cute.home = {
    enable = lib.mkEnableOption "";
    ags = lib.mkEnableOption "";
    eww = lib.mkEnableOption "";
    themes = {
      firefox = lib.mkEnableOption "";
    };
  };
  config = let
    inherit (config.cute.home) enable ags eww;
    inherit (config.cute.home.themes) firefox;
  in {
    home-manager = lib.mkIf enable {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs;};
      users.pagu = {
        imports = [inputs.ags.homeManagerModules.default];
        home = {
          username = "pagu";
          homeDirectory = "/home/pagu";
          stateVersion = "23.05";
          packages = with pkgs; [
            jq
            socat
          ];
          file.".mozilla/firefox/pagu/chrome/userChrome.css".source = lib.mkIf firefox ./themes/firefox.css;
        };
        programs = {
          ags = lib.mkIf ags {
            enable = true;
            configDir = ./ags;
            #extraPackages = with pkgs; [];
          };
          eww = lib.mkIf eww {
            enable = true;
            package = pkgs.eww-wayland;
            configDir = ./eww;
          };
        };
      };
    };
  };
}
