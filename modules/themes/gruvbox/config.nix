{
  config,
  lib,
  _lib,
  pkgs,
  ...
}: let
  inherit (lib) mkMerge mkIf mkDefault;
  inherit (config.cute.programs.cli) nvim;
  inherit (config.cute.programs.gui) vscode;
  inherit (config.cute.theme) name gtk;
in
  mkIf (name == "gruvbox") (mkMerge [
    (mkIf gtk {
      assertions = _lib.assertHm;
      home-manager.users.pagu = {
        gtk = {
          theme = {
            package = pkgs.gruvbox-gtk-theme;
            name = mkDefault "Gruvbox-Light";
          };
          iconTheme = {
            package = pkgs.gruvbox-gtk-theme;
            name = mkDefault "Gruvbox-Light";
          };
        };
        home.pointerCursor = {
          package = pkgs.capitaine-cursors-themed;
          name = mkDefault "Capitaine Cursors (Gruvbox) - White";
          size = 24;
          gtk.enable = true;
          x11.enable = true;
        };
      };
      specialisation.dark.configuration = {
        home-manager.users.pagu = {
          gtk = {
            theme.name = "Gruvbox-Dark";
            iconTheme.name = "Gruvbox-Dark";
          };
          home.pointerCursor.name = "Capitaine Cursors (Gruvbox)";
        };
      };
    })
    (mkIf nvim {
      programs.nixvim = {
        extraPlugins = [pkgs.vimPlugins.lightline-gruvbox-vim];
        extraConfigVim = "let g:lightline_gruvbox_style = 'hard'";
        colorschemes.gruvbox = {
          enable = true;
          settings = {
            contrast = "hard";
          };
        };
      };
    })
    (mkIf vscode {
      assertions = _lib.assertHm;
      home-manager.users.pagu.programs.vscode = {
        extensions = [pkgs.vscode-extensions.jdinhlife.gruvbox];
        userSettings."workbench.colorTheme" = mkDefault "Gruvbox Light Hard";
      };
      specialisation.dark.configuration = {
        home-manager.users.pagu.programs.vscode = {
          userSettings."workbench.colorTheme" = "Gruvbox Dark Hard";
        };
      };
    })
  ])