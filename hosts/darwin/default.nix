{ config, pkgs, ... }:

let user = "erik"; in

{
  imports = [
    ../../modules/darwin/home-manager.nix
    ../../modules/shared # shared entry: nixpkgs flags, overlays
    ../../modules/shared/aliases.nix
    ./disable-default-hotkeys.nix
  ];

  nix = {
    package = pkgs.nix;

    settings = {
      trusted-users = [ "@admin" "${user}" ];
      substituters = [ "https://nix-community.cachix.org" "https://cache.nixos.org" ];
      trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
    };

    gc = {
      automatic = true;
      interval = { Weekday = 0; Hour = 2; Minute = 0; };
      options = "--delete-older-than 30d";
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.systemPackages = with pkgs; [
    # Darwin-only pkgs here
    # TODO: why here since we have modules/darwin/packages.nix?
  ] ++ (import ../../modules/shared/packages.nix { inherit pkgs; });

  # Sudo using TouchID
  security.pam.services.sudo_local.touchIdAuth = true;

  # Tailscale service
  services.tailscale.enable = true;

  system = {
    checks.verifyNixPath = false;
    primaryUser = user;
    stateVersion = 5;

    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 2;         # 120, 90, 60, 30, 12, 6, 2
        InitialKeyRepeat = 15; # 120, 94, 68, 35, 25, 15
        AppleShowAllExtensions = true;
        "com.apple.mouse.tapBehavior" = 1;
        "com.apple.keyboard.fnState" = true; # f1-12 without fn key
      };

      dock = {
        autohide = false;
        show-recents = false;
        launchanim = true;
        orientation = "bottom";
        tilesize = 36;
      };
    };
  };

  # Following line should allow us to avoid a logout/login cycle when changing settings
  # https://github.com/nix-darwin/nix-darwin/issues/518#issuecomment-2906740167
  system.activationScripts.postActivation.text = ''    
    sudo -u ${user} /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
