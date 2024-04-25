{ self, ... }:

{
  imports = with self; [
    nixosModules.systemModules
  ];
  users.users.martin = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
  networking.hostName = "hyperion";
  system.stateVersion = "23.11";
  systemModules = {
    basics = {
      home-manager.enable = true;
      locale.enable = true;
      nix-flakes.enable = true;
      nix-index.enable = true;
      security.enable = true;
    };
    greeters = {
      tuigreet.enable = true;
    };
    hardware.thinkpad-t440p = {
      enable = true;
      disko.enable = true;
    };
  };
  home-manager.users.martin = { osConfig, ... }:
  {
    imports = with self; [
      nixosModules.homeModules
    ];
    home.stateVersion = osConfig.system.stateVersion;
    homeModules = {
      basics = {
        home-manager.enable = true;
        xdg.enable = true;
      };
      desktops = {
        hyprland.enable = true;
      };
      programs = {
        neovim.enable = true;
        chromium.enable = true;
      };
    };
  };
}
