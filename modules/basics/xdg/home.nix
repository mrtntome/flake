{ self, osConfig, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeModules.basics.xdg;
in
{
  options.homeModules.basics.xdg = {
    enable = mkEnableOption "xdg home config";
  };
  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
        documents = "documents";
        download = "downloads";
        pictures = "media/pictures";
        music = "media/music";
        videos = "media/videos";
        desktop = null;
        publicShare = null;
        templates = null;
        extraConfig = {
          XDG_MEDIA_DIR = "media";
          XDG_DEV_DIR = "dev";
          XDG_MISC_DIR = "misc";
        };
      };
    };
  };
}
