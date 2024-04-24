{ self, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.systemModules.basics.locale;
in
{
  options.systemModules.basics.locale = {
    enable = mkEnableOption "locale system config";
    tz = mkOption {
      description = "";
      type = types.str;
      default = "America/Argentina/Buenos_Aires";
    };
    defaultLocale = mkOption {
      description = "";
      type = types.str;
      default = "en_GB.UTF-8";
    };
    extraLocale = mkOption {
      description = "";
      type = types.str;
      default = "es_AR.UTF-8";
    };
  };

  config = mkIf cfg.enable {
    # Time Zone and Locale
    time.timeZone = cfg.tz;
    i18n = {
      defaultLocale = cfg.defaultLocale;
      extraLocaleSettings = {
        LC_ADDRESS = cfg.extraLocale;
        LC_IDENTIFICATION = cfg.extraLocale;
        LC_MEASUREMENT = cfg.extraLocale;
        LC_MONETARY = cfg.extraLocale;
        LC_NAME = cfg.extraLocale;
        LC_NUMERIC = cfg.extraLocale;
        LC_PAPER = cfg.extraLocale;
        LC_TELEPHONE = cfg.extraLocale;
        LC_TIME = cfg.extraLocale;
      };
    };
  };
}
