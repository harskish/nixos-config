{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    wget
    vscode
    brave
    noto-fonts-cjk-sans  # jp font
    unixtools.ping
    glxinfo
    ffmpeg
    pdftk
    killall
  ];

  # Brave kwallet popup fuckery:
  # 1. sudo rm /home/erik/.local/share/kwalletd/kdewallet.*
  # 2. Popup will show up, select blowfish, provide empty password

  # Via Home-manager
  # programs.vscode.enable = true;

  # programs.firefox.enable = true;

  programs.git.enable = true;
  programs.git.config = {
    user.email = "erik.harkonen@hotmail.com";
    user.name = "Erik Härkönen";
    init.defaultBranch = "main";
  };
}