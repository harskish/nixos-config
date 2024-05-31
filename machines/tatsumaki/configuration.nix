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
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "tatsumaki-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  # Aliases
  environment.shellAliases = {
    nixconf = "sudo code --no-sandbox --user-data-dir=~/.vscode /etc/nixos/configuration.nix"; # vscode
    gst = "git status";
    slog = "git log --oneline -20";
  };

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

  # Configure console keymap
  console.keyMap = "fi";

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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.erik = {
    isNormalUser = true;
    description = "Erik";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kate
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages: just binaries added to path
  # Configuration cannot be declared unlike programs
  environment.systemPackages = with pkgs; [
    wget
    vscode
    brave
    conda
  ];

  # Git
  programs.git.enable = true;
  programs.git.config = {
    init = {
      defaultBranch = "main";
    };
    user = {
      email = "erik.harkonen@hotmail.com";
      name = "Erik Härkönen";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
