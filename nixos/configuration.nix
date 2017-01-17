# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/nvme0n1p4";
      preLVM = true;
    }
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/nvme0n1"; # or "nodev" for efi only
  boot.kernelPackages = pkgs.linuxPackages_4_8;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.09";

  networking = {
    hostName = "island";
    wireless.enable = true;
    firewall.enable = false;
    nameservers = ["8.8.8.8" "8.8.4.4"];
  };

  services = {
    ntp.enable = true;
    printing.enable = true;

   redshift = {
      enable = true;
      brightness.day = "0.8";
      brightness.night = "0.3";
      temperature.night = 1000;
      latitude = "37.7749";
      longitude = "122.4194";
    };

    xserver = {
      enable = true;
      exportConfiguration = true;

      resolutions = [ { x = 2048; y = 1152; } ];
      layout = "gb_mac";
      xrandrHeads = [ "eDP1" "DP1" ];
      windowManager.stumpwm.enable = true;
      windowManager.default = "stumpwm";
      desktopManager.default = "none";
      displayManager.slim.defaultUser = "docker";

      synaptics = {
        enable = true;
        maxSpeed = "2.5";
        twoFingerScroll = true;
      };

      # multitouch = {
      #   enable = true;
      #   invertScroll = true;
      # };
    };
  };

  time.timeZone = "America/Los_Angeles";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    fonts = [ pkgs.dejavu_fonts ];
  };

  environment.systemPackages = with pkgs; [
  	neovim
	google-chrome
	slack
	tmux
	git
	fzf
	zsh
  	curl
	wget
	python3
	go
	keychain
	tig
	remake
	ctags
	gcc
	tree
	iptables
	iproute
	bridge-utils
	utillinux
	stumpwm
	xlibs.xmodmap
	xsel
	redshift
	htop
	remake
	tig
  ];

  nixpkgs.config = {
    allowUnfree = true;
    google-chrome = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
  };

  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
  };

  environment.shells = [
    "/run/current-system/sw/bin/zsh"
  ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "overlay2";
  };

  users.extraUsers.docker = {
    name = "docker";
    group = "docker";
    extraGroups = [
      "wheel" "disk" "audio" "video" "networkmanager" "systemd-journal"
    ];
    createHome = true;
    home = "/home/docker";
    uid = 1000;
    shell = "/run/current-system/sw/bin/zsh";
  };
}
