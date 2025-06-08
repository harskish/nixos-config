# Overview

## Importing order:

```
- nix run .#build-switch
  - nix build .#darwinConfigurations.aarch64-darwin.system"
    - flake.nix: darwinConfigurations
      - hosts/darwin/default.nix
          - modules/darwin/home-manager.nix
              - modules/darwin/casks.nix
              - modules/darwin/files.nix
              - modules/shared/home-manager.nix
              - modules/shared/files.nix 
          - modules/shared/default.nix (applies overlays)
          - modules/shared/aliases.nix
          - modules/shared/packages.nix>
```