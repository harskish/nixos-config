{ config, pkgs, ... }:

{
  # Locale
  i18n.defaultLocale = "fi_FI.UTF-8";

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";
  
  # Configure keymap
  console.keyMap = "fi";
  services.xserver.xkb.layout = "fi"; # needed despite no x11
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
}