{ self, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.systemModules.greeters.regreet;
in
{
  options.systemModules.greeters.regreet = {
    enable = mkEnableOption "regreet greeter config";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cage
      greetd.regreet
      gruvbox-gtk-theme
      capitaine-cursors-themed
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.cage}/bin/cage -s -- regreet";
          user = "greeter";
        };
      };
    };

    programs.regreet = {
      enable = true;
      settings = {
        GTK = {
          font_name = "SauceCodeProNerdFont-SemiBold 16";
          cursor_theme_name = "Capitaine Cursors (Gruvbox)";
          icon_theme_name = "Adwaita";
          theme_name = "Gruvbox-Dark-B";
        };
      };
    };
  };
}
