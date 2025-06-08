# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# sudo nixos-rebuild {build, test, boot, switch}
# nixos-version

# Updating NixOS
# Check available channels form https://channels.nixos.org/
# Check current: `sudo nix-channel --list | grep nixos`
# Switch to root: `sudo su`
# Set new channel for whole system: `nix-channel --add https://channels.nixos.org/nixos-24.05 nixos`
# Go back to user account and verify: `exit; sudo nix-channel --list`
# Perform upgrade: `sudo nixos-rebuild switch --upgrade`
# If EFI partition is full and prevents upgrade:
#   1. Remove symlinks to old generations from /nix/var/nix/profiles
#   2. sudo nix-collect-garbage
#   3. sudo /run/current-system/bin/switch-to-configuration switch
#   4. Retry upgrade

{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../shared/local-hardware-clock.nix
    ../../shared/user.nix
    ../../shared/locale.nix
    ../../shared/aliases.nix
    ../../shared/programs.nix
  ];

  # Bootloader: make Windows the default
  # Admin CMD: `mountvol Q: /s && nano Q:\loader\loader.conf`
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    extraInstallCommands = ''
      echo "title Windows" > /boot/loader/entries/windows.conf
      echo "efi /EFI/Microsoft/Boot/bootmgfw.efi" >> /boot/loader/entries/windows.conf
      #echo "timeout 5" > /boot/loader/loader.conf
      #echo "default windows.conf" >> /boot/loader/loader.conf
      #echo "console-mode keep" >> /boot/loader/loader.conf
    '';
  };

  networking.hostName = "tatsumaki-nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Pure-wayland Plasma 6
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.xserver.enable = false;
  services.displayManager = {
    defaultSession = "plasma"; # wayland by default in plasma6  
    autoLogin.user = "erik";
    autoLogin.enable = true;
  };

  # Broken scaling in Electron-based apps (Brave/VSCode) under Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  
  # RTX 2080
  hardware.nvidia = {
    modesetting.enable = true;           # required
    powerManagement.enable = false;      # experimental, enable if glitches after sleep
    powerManagement.finegrained = false; # turn off GPU when not in use; Turing+
    open = false;                        # open source kernel module (!= nouveau)
    nvidiaSettings = true;               # settings app
    package = config.boot.kernelPackages.nvidiaPackages.production; # 550
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # First version of NixOS installed on this machine.
  # Defines the format of stateful data (config files etc.)
  system.stateVersion = "23.11";

}
