{ config, pkgs, lib, home-manager, ... }:

let
  user = "erik";
  # Define the content of your file as a derivation
  myEmacsLauncher = pkgs.writeScript "emacs-launcher.command" ''
    #!/bin/sh
    emacsclient -c -n &
  '';
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
   ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  # NB: this attribute set is a part of nix-darwin, not home-manager, despite filename!
  # A Brewfile is produced as a result of these parameters
  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
    
    # github.com/zhaofengli/nix-homebrew/issues/5#issuecomment-1878798641
    taps = builtins.attrNames config.nix-homebrew.taps;
    onActivation.cleanup = "zap";

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)
    masApps = {
      # NB: these require xcode command line tools (trying to avoid!)
      #"Ente Auth" = 6444121398; # not being installed...!
      #"Tailscale" = 1475387142;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
          { "emacs-launcher.command".source = myEmacsLauncher; }
        ];
        stateVersion = "23.11";
      };
      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      manual.manpages.enable = false;
    };
  };

  # Fully declarative dock using the latest from Nix Store
  local.dock = {
    enable = true;
    username = user;
    entries = [
    { path = "/Applications/Slack.app/"; } # cask
    { path = "/Applications/Brave\ Browser.app/"; } # cask
    { path = "/System/Applications/Utilities/Terminal.app/"; }
    { path = "/Applications/Ente Auth.app/"; }
    {
      path = "/Applications";
      section = "others";
      options = "--sort name --view grid --display stack";
    }
    {
      path = "${config.users.users.${user}.home}/Downloads";
      section = "others";
      options = "--sort name --view grid --display stack";
    }
  ];
  };

}
