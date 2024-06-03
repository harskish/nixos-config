# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./apple-silicon-support
    ];

  # Specify path to peripheral firmware files
  # => seems broken
  # hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Networking
  networking.hostName = "nixos"; # hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Aliases
  environment.shellAliases = {
    # NB: using ~ might create dummy ./~ dirs everywhere
    nixconf = "sudo code --no-sandbox --user-data-dir=$HOME/.vscode /etc/nixos/configuration.nix";
    gst = "git status";
    slog = "git log --oneline -20";
  };
  
  # Configure keymap
  console.keyMap = "fi";
  services.xserver.xkb.layout = "fi"; # needed despite no x11
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Hyprland:
  # https://www.youtube.com/watch?v=Nfm3oyJx_Hk
  # https://github.com/JaKooLit/Fedora-Hyprland

  # Pure wayland Plasma 6
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.xserver.enable = false;
  services.displayManager = {
    defaultSession = "plasma";
  };

  # Enable OpenGL
  hardware.opengl.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.erik = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vscode
    brave
    unixtools.ping
  ];

  programs.git.enable = true;
  programs.git.config = {
    user.email = "erik.harkonen@hotmail.com";
    user.name = "Erik Härkönen";
    init.defaultBranch = "main";
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

