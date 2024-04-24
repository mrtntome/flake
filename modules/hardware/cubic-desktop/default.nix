{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.systemModules.hardware.cubic-desktop;
in
{
  imports = [
    ./disko.nix
  ];
  options.systemModules.hardware.cubic-desktop = {
    enable = mkEnableOption "cubic-desktop hardware config";
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
      ROC_ENABLE_PRE_VEGA = "1";
    };

    hardware.opengl.extraPackages = with pkgs; [
      rocmPackages.clr.icd
      amdvlk
      libva
    ];

    hardware.opengl.driSupport = true;
    hardware.opengl.driSupport32Bit = true;

    # kernel modules
    boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "ohci_pci" "ehci_pci" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ "amdgpu" ];
    boot.extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];
    boot.kernelModules = [ "kvm-amd" "amdgpu" "i2c-dev" "ddcci_backlight" ];
    boot.kernelParams = ["quiet"];

    # firmware and microcode
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    # networking
    networking.networkmanager.enable = true;
    networking.useDHCP = lib.mkDefault true;

    # power and brightness
    environment.systemPackages = with pkgs; [
      brightnessctl
      ddcutil
    ];
    nixpkgs.system = "x86_64-linux";
  };
}
