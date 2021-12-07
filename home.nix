{ config, pkgs, ... }:

{
  imports = [
    ./config/nvim/nvim.nix # Todo
  ];

  # Git
  programs.git = {
    enable = true;
    userName = "Yabanahano";
    userEmail = "yabanahano.fui@gmail.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  # Xmonad
  home.file.".xmonad/xmonad.hs".source = ./config/xmonad/xmonad.hs;

  # Do not touch
  # home.stateVersion = "22.05";
}
