{ self, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.systemModules.hardware.intel-nuc.disko;
in
{
  options.systemModules.hardware.intel-nuc.disko = {
    enable = mkEnableOption "intel-nuc disko config";
  };
  config = mkIf cfg.enable {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-path/pci-0000:00:12.0-ata-1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
