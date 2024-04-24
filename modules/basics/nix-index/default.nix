{ self, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.systemModules.basics.nix-index;
in
{
  options.systemModules.basics.nix-index = {
    enable = mkEnableOption "nix-index system config";
  };
  config = mkIf cfg.enable {
    # Nix Index
    programs.command-not-found.enable = false;
    programs.nix-index = {
      enable = true;
    };
  };
}
