{ self, ... }:

{
  systemModules = {
    imports = [
      ./basics/home-manager
      ./basics/locale
      ./basics/nix-flakes
      ./basics/nix-index
      ./basics/security
      ./greeters/tuigreet
      ./greeters/regreet
      ./hardware/cubic-desktop
      ./hardware/intel-nuc
      ./hardware/thinkpad-t440p
      self.inputs.disko.nixosModules.disko
      self.inputs.home-manager.nixosModules.home-manager
    ];
  };
  homeModules = {
    imports = [
      ./basics/home-manager/home.nix
      ./basics/xdg/home.nix
      ./desktops/hyprland/home.nix
      ./programs/neovim/home.nix
      ./programs/browsers/chromium/home.nix
      self.inputs.nixvim.homeManagerModules.nixvim
    ];
  };
}
