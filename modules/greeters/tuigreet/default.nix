{ self, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.systemModules.greeters.tuigreet;
in
{
  options.systemModules.greeters.tuigreet = {
    enable = mkEnableOption "tuigreet greeter config";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      greetd.tuigreet
    ];

    services.greetd = {
      enable = true;
      vt = 1;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet -t -r --remember-session -s ${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions --asterisks --asterisks-char x";
          user = "greeter";
        };
      };
    };    
  };
}
