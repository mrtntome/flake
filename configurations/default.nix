inputs@{ self, ... }:
let 
mkConfig = path:
  inputs.nixpkgs.lib.nixosSystem {
    specialArgs = inputs;
    modules = [ path ];
  };
in 
{
  hyperion = mkConfig ./hyperion/configuration.nix;
}
