{ pkgs, config, ... }:


let
  haskellPackages = with pkgs.haskellPackages; [
    xmonad xmonad-contrib xmonad-extras
  ];

  regularPackages = with pkgs; [
    # Rice/Desktop
    rofi feh dunst

    # CMD Tools
    neovim-nightly wget neofetch killall
    ffmpeg unzip exa brightnessctl

    # GUI Application
    firefox kitty gimp gnome.nautilus

    # Development
    lua git gcc python2 python3
  ];

  homePackages = with pkgs; [
    fzf
  ];
in
{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];

  environment.systemPackages = regularPackages ++ haskellPackages;
  home-manager.users.yabanahano.home.packages = homePackages;
}
