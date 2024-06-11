{ config, pkgs, ... }:

{
  # Change hardware clock to local time
  # For compatibility with dual-booted Windows
  time.hardwareClockInLocalTime = true;
}