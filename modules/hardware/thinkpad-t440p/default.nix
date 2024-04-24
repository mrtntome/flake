{ self, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.systemModules.hardware.thinkpad-t440p;
in
{
  imports = [
    ./disko.nix
  ];
  options.systemModules.hardware.thinkpad-t440p = {
    enable = mkEnableOption "thinkpad-t440p hardware config";
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

    # bluetooth
    hardware.bluetooth.enable = true;

    # bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.initrd.systemd.enable = true;
    
    services.fstrim.enable = lib.mkDefault true;

    # gpu
    environment.variables = {
      VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
    };

    hardware.opengl.extraPackages = with pkgs; [
      (if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then vaapiIntel else intel-vaapi-driver)
      libvdpau-va-gl
      intel-media-driver
    ];

    # input
    services.xserver.libinput.enable = lib.mkDefault true;
    hardware.trackpoint.enable = lib.mkDefault true;
    hardware.trackpoint.emulateWheel = lib.mkDefault config.hardware.trackpoint.enable;

    # kernel modules
    boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    boot.initrd.kernelModules = [ ];
    boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
    boot.kernelModules = [ "kvm-intel" "i915" "i2c-dev" "ddcci_backlight" ];
    boot.kernelParams = ["quiet"];
    boot.consoleLogLevel = 3;


    # firmware and microcode
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    # networking
    networking.networkmanager.enable = true;
    networking.useDHCP = lib.mkDefault true;

    # power and brightness
    environment.systemPackages = with pkgs; [
      acpi
      brightnessctl
      ddcutil
    ];
    boot = {
      extraModprobeConfig = ''
      options bbswitch use_acpi_to_detect_card_state=1
      options thinkpad_acpi force_load=1 fan_control=1
    '';
    };
    
    services.tlp.enable = lib.mkDefault true;
    nixpkgs.system = "x86_64-linux";
  };
}
