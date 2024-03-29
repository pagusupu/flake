{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.nix-gaming.nixosModules.pipewireLowLatency];
  options.cute.desktop = {
    xdg = lib.mkEnableOption "";
    fonts = lib.mkEnableOption "";
    audio = lib.mkEnableOption "";
    greetd = {
      enable = lib.mkEnableOption "";
      command = lib.mkOption {type = lib.types.str;};
    };
  };
  config = let
    inherit (config.cute.desktop) xdg greetd fonts audio;
    inherit (config.cute.home) enable;
  in {
    home-manager.users.pagu = lib.mkIf enable {
      xdg = lib.mkIf xdg {
        enable = true;
        userDirs = {
          enable = true;
          desktop = "\$HOME/deskto";
          documents = "\$HOME/documents";
          download = "\$HOME/downloads";
          pictures = "\$HOME/pictures";
          videos = "\$HOME/pictures/videos";
        };
        desktopEntries = let
          no = {noDisplay = true;};
        in {
          Alacritty = no // {name = "alacritty";};
          nixos-manual = no // {name = "NixOS Manual";};
          nvim = no // {name = "Neovim Wrapper";};
          firefox = {
            name = "Firefox";
            exec = "firefox";
            terminal = false;
          };
        };
      };
    };
    services = {
      greetd = lib.mkIf greetd.enable {
        enable = true;
        settings = rec {
          initial_session = {
            command = greetd.command;
            user = "pagu";
          };
          default_session = initial_session;
        };
      };
      pipewire = lib.mkIf audio {
        enable = true;
        jack.enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        lowLatency = {
          enable = true;
          quantum = 192;
          rate = 192000;
        };
      };
    };
    fonts = lib.mkIf fonts {
      packages = with pkgs; [
        lato
        nerdfonts
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        noto-fonts-extra
        (pkgs.callPackage ../../pkgs/sora.nix {})
      ];
      fontconfig = {
        enable = true;
        antialias = true;
        subpixel.rgba = "rgb";
        hinting = {
          enable = true;
          autohint = true;
        };
        defaultFonts = {
          emoji = ["Noto Color Emoji"];
          monospace = ["MonaspiceNe Nerd Font"];
          sansSerif = ["Sora"];
          serif = ["Lato"];
        };
      };
    };
    security.rtkit.enable = lib.mkIf audio true;
    hardware.pulseaudio.enable = lib.mkIf audio false;
  };
}
