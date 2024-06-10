# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./apple-silicon-support
      ../../shared/user.nix
      ../../shared/locale.nix
      ../../shared/aliases.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "apple_dcp.show_notch=1" ];
  
  # Networking
  networking.hostName = "mbp14-nixos"; # hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Pure wayland Plasma 6
  # Panel settings for hiding MBP14 notch:
  # 1. Right-click panel, enter edit mode
  # 2. Position top, fill width, height 32, non-floating
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.xserver.enable = false;
  services.displayManager = {
    defaultSession = "plasma";
    autoLogin.user = "erik";
    autoLogin.enable = true;
  };

  # Broken scaling in Electron-based apps (Brave/VSCode) under Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Asahi GPU driver & firmware
  hardware.asahi = {
    withRust = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    peripheralFirmwareDirectory = ./firmware;
  };

  # Enable OpenGL
  hardware.opengl.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    wget
    vscode
    brave
    unixtools.ping
    glxinfo
    mesa-asahi-edge
    ffmpeg
  ];

  programs.firefox.enable = true;

  programs.git.enable = true;
  programs.git.config = {
    user.email = "erik.harkonen@hotmail.com";
    user.name = "Erik Härkönen";
    init.defaultBranch = "main";
  };

  # First installed NixOS version (not necessarily current)
  system.stateVersion = "24.05";

}

