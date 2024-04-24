{ self, osConfig, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeModules.programs.neovim;
in
{
  options.homeModules.programs.neovim = {
    enable = mkEnableOption "neovim config";
  };
  config = mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "nvim";
    };
    programs.nixvim = {
      enable = true;
      extraPackages = with pkgs; [];
      extraPlugins = with pkgs.vimPlugins; [
        lazygit-nvim
        fzf-lua
        nvim-base16
      ];
      extraConfigVim = "";
      colorschemes."gruvbox".enable = true;
      colorscheme = "gruvbox";
      plugins = {
        nix.enable = true;
        lualine = {
          enable = true;
        };
        treesitter.enable = true; 
        zk.enable = true;
      };
    };
  };
}
