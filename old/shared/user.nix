{ config, pkgs, ... }:

{
  # Define a user account.
  # Don't forget to set a password with ‘passwd’.
  users.users.erik = {
    isNormalUser = true;
    description = "Erik";
    extraGroups = [
        "networkmanager"
        "wheel"  # enable sudo
    ];
  };
}