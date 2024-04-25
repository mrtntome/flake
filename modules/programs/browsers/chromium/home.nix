{ self, osConfig, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeModules.programs.chromium;
in
{
  options.homeModules.programs.chromium = {
    enable = mkEnableOption "ungoogled-chromium config";
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
      extensions =
      let
        createChromiumExtensionFor = browserVersion: {id, sha256, version}:
          {
            inherit id;
            crxPath = builtins.fetchurl {
              url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
              name = "${id}.crx";
              inherit sha256;
            };
            inherit version;
          };
        createChromiumExtension = createChromiumExtensionFor (lib.versions.major pkgs.ungoogled-chromium.version);
        ublock-origin = {
          id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
          sha256 = "sha256:0fsygwn7rff79405fr96j89i9fx7w8dl3ix9045ymgm0mf3747pd";
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
        [
          (createChromiumExtension ublock-origin)
          (createChromiumExtension privacy-badger)
          (createChromiumExtension vimium)
        ];
    };
  };
}
