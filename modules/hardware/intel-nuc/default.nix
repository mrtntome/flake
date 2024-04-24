{ self, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.systemModules.hardware.intel-nuc;
in
{
  imports = [
    ./disko.nix
  ];
  options.systemModules.hardware.intel-nuc = {
    enable = mkEnableOption "intel-nuc hardware config";
  };
  config = mkIf cfg.enable {
    # audio
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # gpu
    hardware.opengl.extraPackages = with pkgs; [
      (if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then vaapiIntel else intel-vaapi-driver)
      libvdpau-va-gl
      intel-media-driver
    ];
    environment.variables = {
      VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    };

    # bluetooth
    hardware.bluetooth.enable = true;

    # bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd.systemd.enable = true;
    
    # ssd
    services.fstrim.enable = lib.mkDefault true;

    # kernel modules
    boot.initrd.availableKernelModules = [ "usbhid" "ehci_pci" "xhci_pci" "usb_storage" "ahci" "sd_mod" "sdhci_pci" ];
    boot.initrd.kernelModules = [ ];
    boot.extraModulePackages = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.kernelParams = ["quiet"];
#    boot.consoleLogLevel = lib.mkDefault 3;

    # firmware and microcode
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    # networking
    networking.networkmanager.enable = true;
    networking.useDHCP = lib.mkDefault true;

    # power and brightness
    services.thermald.enable = lib.mkDefault true;
    services.tlp.enable = lib.mkDefault true;
    nixpkgs.system = "x86_64-linux";
  };
}
