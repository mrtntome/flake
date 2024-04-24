{ self, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.systemModules.basics.nix-flakes;
in
{
  options.systemModules.basics.nix-flakes = {
    enable = mkEnableOption "nix-flakes system config";
  };
  config = mkIf cfg.enable {
    # nix flakes
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = "experimental-features = nix-command flakes";
      registry.nixpkgs.flake = self.inputs.nixpkgs;
      nixPath = [
        # channels compat
        "nixpkgs=${self.inputs.nixpkgs}"
      ];
    };
  };
}
