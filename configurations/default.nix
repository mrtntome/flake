inputs@{ self, ... }:

{
  hyperion = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = inputs;
    modules = [
      ./hyperion/configuration.nix
    ];
  };
}
