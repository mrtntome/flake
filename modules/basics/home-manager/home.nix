{ self, osConfig, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeModules.basics.home-manager;
in
{
  options.homeModules.basics.home-manager = {
    enable = mkEnableOption "home-manager home config";
  };
  config = mkIf cfg.enable {
    programs.home-manager.enable = true;
    home.stateVersion = osConfig.system.stateVersion;
  };
}
