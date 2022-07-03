{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    blacklistedKernelModules = [ "snd_pcsp" ];
    kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [
      "exfat"
    ];
  };

  swapDevices = [
    { device = "/swapfile"; size = 32768; }
  ];

  networking = {
    firewall = {
      enable = false;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    hostName = "nixos";
    networkmanager.enable = true;
  };

  # Select internationalisation properties.
  i18n = {
    consoleKeyMap = colemak;
    defaultLocale = "en_GB.UTF-8";
  };

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  services = {

    ntp.enable = true;

    xserver = {
      videoDrivers = [ "amd" ];
      enable = true;
      layout = "us";

      xkbOptions = "compose:caps";
      xkbVariant = "colemak";

      synaptics.enable = true;

 ###### DESKTOP ENVIRONMENT ######

      desktopManager.gnome.enable = true;
      desktopManager.default = "gnome";

      displayManager.gdm = {
        enable = true;
      };
    };
  };

 ###### TIMEZONE ######

  time.timeZone = "Europe/London";

 ###### USERS ######

  users.extraUsers.alex = {
    createHome = true;
    home = "/home/alex";
    description = " ";
    extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
    useDefaultShell = true;
  };

  nixpkgs.system = "x86_64-linux";
  nixpkgs.config = {
    pulseaudio = true;
    allowUnfree = true;
  };

 ###### PACKAGES ######

  environment.systemPackages = with pkgs;
    [ cacert
      cloc
      elfutils
      neovim
      file
      firefox-bin
      git
      glib
      glxinfo
      gnupg
      gnutls
      jq
      mpv
      mupdf
      networkmanager
      nix-repl
      p7zip
      pavucontrol
      pinentry
      rxvt_unicode
      scrot
      sxiv
      unzip
      wget
      alacritty
      xlibs.xsetroot
      xsel
      zip
    ];

 ###### FONTS ######

  fonts = {
    fontconfig.enable = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      dejavu_fonts
      inconsolata
      source-han-sans-japanese
      source-han-sans-korean
      source-han-sans-simplified-chinese
      source-han-sans-traditional-chinese
      ubuntu_font_family
    ];
  };

  security.sudo.enable = true;

 ###### PACKAGE MANAGER ######

  nix = {
    package = pkgs.nixUnstable;
    trustedBinaryCaches = [
      "http://cache.nixos.org"
    ];

    binaryCaches = [
      "http://cache.nixos.org"
    ];

    gc.automatic = false;
    maxJobs = pkgs.stdenv.lib.mkForce 6;
  };
}