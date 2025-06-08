{ config, pkgs, lib, ... }:

let name = "Erik Härkönen";
    user = "erik";
    email = "erik.harkonen@hotmail.com"; in
{
  # Shared shell configuration
  zsh = {
    enable = true;
    autocd = false;
  };

  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = name;
    userEmail = email;
    lfs = {
      enable = true;
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
	      editor = "nano";
        autocrlf = "input";
      };
      pull.rebase = true;
    };
  };
}
