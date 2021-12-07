# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  # Imports
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    (import "${home-manager}/nixos")
  ];

  # Nix
  nix = {
    package = pkgs.nixUnstable;
  };
  
  # Auto Update
  system = {
    autoUpgrade = {
      enable = true;
    };
  };

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.yabanahano = {
      imports = [ ./home.nix ];
    };
  };

  # Boot loader
  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "/dev/sda";
        useOSProber = true;
      };
    };
  }; 

  # Network 
  networking = {
    hostName = "yui";
    useDHCP = false;
    wireless = {
      enable = true;
      userControlled.enable = true;
    };
    interfaces = {
      enp9s0.useDHCP = true;
      wlp8s0.useDHCP = true;
    };
  };

  # Locales
  time.timeZone = "Asia/Bangkok";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # X Settings
  services = {
    xserver = {
      enable = true;
      layout = "us";
      libinput.enable = true;
      displayManager = {
        lightdm.enable = true;
      };
      desktopManager = {
        xterm.enable = false;
      };
      windowManager = {
	xmonad = {
          enable = true;
          enableContribAndExtras = true;
        };
      };
    };
  };

  # Enable Audio
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Users
  users.users.yabanahano = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # Fonts
  fonts.fonts = with pkgs; [
    (nerdfonts.override {
      fonts = [ 
         "FiraCode"
	 "Hack"
       ];
    })
  ];

  # SSH
  services.openssh.enable = true;

  # Do not touch
  system.stateVersion = "21.11"; # Did you read the comment?
}
