# Overview

## Importing order:

```sh
nix run .#build-switch
apps/<system>/build-switch
nix --extra-experimental-features 'nix-command flakes' build .#darwinConfigurations.aarch64-darwin.system"
flake.nix: darwinConfigurations.aarch64-darwin.system
flake.nix: darwin.lib.darwinSystem
./hosts/darwin

```