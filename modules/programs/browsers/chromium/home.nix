{ self, osConfig, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeModules.programs.chromium;
in
{
  options.homeModules.programs.chromium = {
    enable = mkEnableOption "ungoogled-chromium config";
  };

  config =  
  let
    browserVersion = (lib.versions.major pkgs.ungoogled-chromium.version);
    createChromiumExtension = extension:
    {
      id = extension.id;
      crxPath = builtins.fetchurl {
        url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
        name = "${id}.crx";
        sha256 = extension.sha256;
      };
      version = extension.version;
    };
    ublock-origin = {
      id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
      sha256 = "sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
      version = "1.57.0";
    };
    privacy-badger = {
      id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";
      sha256 = "sha256:109cf67ae1b0df381d96d7a307bde88544d1789cb7f225ed7efc071475a64989";
      version = "2024.2.6";
    };
    vimium = {
      id = "dbepggeogbaibhgnhhndojpepiihcmeb";
      sha256 = "sha256:0da10cd4dc8c5fc44c06f5a82153a199f63f69eeba1c235f4459f002e2d41d55";
      version = "2.1.2";
    };
  in
    mkIf cfg.enable {
      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
        extensions = [
          (createChromiumExtension ublock-origin)
          (createChromiumExtension privacy-badger)
          (createChromiumExtension vimium)
        ];
      };
    };
}
