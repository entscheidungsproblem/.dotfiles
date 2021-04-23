# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let 
    spotify_username = (import /etc/nixos/spotify.nix).username;  
    spotify_password = (import /etc/nixos/spotify.nix).password;  
    spotify_id = (import /etc/nixos/spotify.nix).client_id;
    spotify_secret = (import /etc/nixos/spotify.nix).client_secret;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/2248b3d1-f004-4584-8668-bb45ad56c88d";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 5556 5558 ];

  # Select internationalisation properties.
  i18n = {
  #   consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";
 
  nixpkgs.config = 
  {
    # Allow proprietary packages
    allowUnfree = true;

    # Create an alias for the unstable channel
    packageOverrides = pkgs: 
    {
        unfree = import <nixos> 
            { 
                # pass the nixpkgs config to the unstable alias
                # to ensure `allowUnfree = true;` is propagated:
                config = config.nixpkgs.config; 
            };
    };
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      # Internet
      wget
      curl
      #speedtest-cli
      git
      #firefox
      #unfree.google-chrome
      #transmission
      #transmission-gtk

      # Build Essentials
      gcc

      # Languages
      valgrind
      clang
      clang-tools

      python
      python3

      rustc
      rustup
      rustfmt
      cargo

      perl
      ruby
      nodejs
      processing
      yarn

      # Launcher
      #rofi
      #rofi-pass

      # Text
      neovim
      #libxkbfile  # For onivim
      #libreoffice

      # Terminal
      #kitty
      exa
      #ranger
      #neofetch
      #tmux
      ripgrep
      #thefuck

      # Shell
      zsh
      zsh-completions
      oh-my-zsh
      zsh-autosuggestions
      zsh-syntax-highlighting

      # Extraction
      zip
      unzip
      bzip2
      lbzip2
      gzip
      lzip
      p7zip
      cabextract

      # Media
      #vlc
      #ffmpeg
      #imagemagick
      #ncmpcpp
      #blueman

      # PDF
      #zathura

      # WM
      #compton
      #polybar
      #lemonbar
      #pywal
      #dunst
      #i3lock-fancy
      #nerdfonts
      #lastpass-cli
      #xclip
      #xwinwrap
      #xscreensaver
      #gifsicle

      # Nix
      #nix-prefetch-git
    ];
    variables = {
      TERMINAL = [ "kitty" ];
      OH_MY_ZSH = [ "${pkgs.oh-my-zsh}/share/oh-my-zsh" ];
    };

};
  # Oh-My-ZSH
  #programs.zsh.interactiveShellInit = ''
  #  export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/
  #  source $ZSH/oh-my-zsh.sh
  #'';

  #programs.zsh.promptInit = ""; # Clear this to avoid a conflict with oh-my-zsh
  
  
  #nixpkgs.config.firefox = {
    #enableMPlayer = true;
    #ffmpegSupport = true;
    #enableAdobeFlash = true;
    #enableAdobeReader = true;
    #enableGoogleTalkPlugin = true;
  #};
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  services.mopidy = {
    enable = true;
    extensionPackages = [ pkgs.mopidy-spotify pkgs.mopidy-mopify pkgs.mopidy-spotify-tunigo pkgs.mopidy-youtube ];
    configuration = ''
      [spotify]
      username = "${spotify_username}"
      password ="${spotify_password}"
      client_id ="${spotify_id}"
      client_secret ="${spotify_secret}"
    '';
  };


  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };

  # Enable Bluetooth
  #hardware.bluetooth.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
  services.xserver.windowManager.herbstluftwm.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    extraUsers.lambda = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = ["wheel" "networkmanager" "audio"];
    };
    extraUsers.emily = {
      isNormalUser = true;
      uid = 1001;
      extraGroups = ["networkmanager" "audio"];
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
