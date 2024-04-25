{ self, ... }:

{
  imports = with self; [
    nixosModules.systemModules
  ];

  # Hostanme  
  networking.hostName = "kronos";
  
  # Version
  system.stateVersion = "23.11";
  
  # Users
  users.users.martin = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };
  
  # Modules config
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
    hardware.cubic-desktop = {
      enable = true;
      disko.enable = true;
    };
  };
  
  # Desktop
  programs.hyprland.enable = true;

  # home-manager config
  home-manager.users.martin = { osConfig, ... }:
  {
    imports = with self; [
      nixosModules.homeModules
    ];

    # Version
    home.stateVersion = osConfig.system.stateVersion;
    
    # Modules config
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
