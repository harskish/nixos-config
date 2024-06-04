{ config, pkgs, ... }:

{
  environment.shellAliases = {
    # NB: using ~ might create dummy ./~ dirs everywhere
    #nixconf = "sudo code --no-sandbox --user-data-dir=$HOME/.vscode /etc/nixos/configuration.nix";
    gst = "git status";
    slog = "git log --oneline -20";
  };
}
