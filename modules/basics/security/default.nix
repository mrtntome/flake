{ self, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.systemModules.basics.security;
in
{
  options.systemModules.basics.security = {
    enable = mkEnableOption "security system config";
  };
  config = mkIf cfg.enable {
   # Security
    security.polkit.enable = true;
  };
}
