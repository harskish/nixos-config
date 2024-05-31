# Usage

1. Install NixOS on new HW.
2. Create new subdir in machines, copy `hardware-configuration.nix` over.
3. Create `configuration.nix`, importing shared stuff as needed.
4. Create symlink: `sudo ln -s $(pwd)/configuration.nix /etc/nixos/`.