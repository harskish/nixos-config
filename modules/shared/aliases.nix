{ config, pkgs, ... }:

{
  environment.shellAliases = {
    # NB: using ~ might create dummy ./~ dirs everywhere
    gst = "git status";
    slog = "git log --oneline -20";
  };
}
