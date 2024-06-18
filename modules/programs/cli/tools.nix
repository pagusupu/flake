{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;
in {
  options.cute.programs.cli = {
    ssh = mkEnableOption "";
    btop = mkEnableOption "";
    nh = mkEnableOption "";
    yazi = mkEnableOption "";
  };
  config = let
    inherit (config.cute.programs.cli) ssh btop nh yazi;
  in
    mkMerge [
      (mkIf ssh {
        services.openssh = {
          enable = true;
          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
          };
        };
        users.users.pagu.openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMGwCFQYJB+4nhIqktQwJemynSOEP/sobnV2vESSY3tk" # rin
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIqJoNQ+5r3whthoNHP3C++gI/KE6iMgrD81K6xDQ//V" # desktop win
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqzdZDv69pd3yQEIiq79vRKrDE5PlxINJFhpDvpE/vR" # laptop
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBiWUZRqsWDA78zsv3LJVcWjIiUdnecPoOi8+ZddxRSa" # phone
        ];
      })
      (mkIf btop {
        homefile."btop" = {
          target = ".config/btop/btop.conf";
          source = (pkgs.formats.toml {}).generate "btop.conf" {
            color_theme = "TTY";
            theme_background = false;
            proc_sorting = "name";
            proc_tree = true;
            proc_left = true;
            proc_filter_kernel = true;
            show_swap = false;
            show_io_stat = false;
            show_battery = false;
            net_iface = "${config.cute.net.interface}";
          };
        };
        environment.systemPackages = [pkgs.btop];
      })
      (mkIf nh {
        programs.nh = {
          enable = true;
          flake = "/home/pagu/camp/";
          clean = {
            enable = true;
            extraArgs = "--keep 10 --keep-since 3d";
          };
        };
      })
      (mkIf yazi {
        homefile."yazi" = {
          target = ".config/yazi/yazi.toml";
          source = (pkgs.formats.toml {}).generate "yazi.toml" {
            manager = {
              sort_by = "natural";
              sort_dir_first = true;
            };
          };
        };
        environment.systemPackages = [pkgs.yazi];
      })
    ];
}
