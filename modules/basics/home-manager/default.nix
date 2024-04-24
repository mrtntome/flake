{ self, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.systemModules.basics.home-manager;
in
{
  options.systemModules.basics.home-manager = {
    enable = mkEnableOption "home-manager system config";
  };
  config = mkIf cfg.enable {
    # home-manager global config
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
