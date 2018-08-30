# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let 
    spotify_username = (import /etc/nixos/spotify.nix).username;  
    spotify_password = (import /etc/nixos/spotify.nix).password;  
    spotify_id = (import /etc/nixos/spotify.nix).client_id;
    spotify_secret = (import /etc/nixos/spotify.nix).client_secret;
    vpn_username = (import /etc/nixos/vpn.nix).username;  
    vpn_password = (import /etc/nixos/vpn.nix).password;  
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./fonts.nix
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
      git

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

      # Text
      neovim

      exa
      ripgrep

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

      #vlc
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
    extensionPackages = [ pkgs.mopidy-spotify pkgs.mopidy-mopify pkgs.mopidy-spotify-tunigo pkgs.mopidy-local-images pkgs.mopidy-youtube ];
    configuration = ''
      [spotify]
      username = "${spotify_username}"
      password ="${spotify_password}"
      client_id ="${spotify_id}"
      client_secret ="${spotify_secret}"
    '';
  };

  services.searx.enable = true;

  # Media Server
  #services.transmission.enable = true;
  #services.jackett.enable = true;
  #services.sonarr.enable = true;
  #services.radarr.enable = true;
  #services.plex.enable = true;
  #services.plex.openFirewall = true;
  
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [pkgs.gutenprint pkgs.gutenprintBin pkgs.brgenml1cupswrapper pkgs.brgenml1lpr pkgs.foomatic_filters ]; 
    #[ pkgs.gutenprint];
  };

  services.openvpn.servers = {
    nord = { 
      config = '' config /home/lambda/.vpn/ovpn_udp/ca229.nordvpn.com.udp.ovpn '';
      authUserPass.username = "${vpn_username}";
      authUserPass.password = "${vpn_password}";
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };

  # For Steam
  hardware.opengl.driSupport32Bit = true;

  # Enable Bluetooth
  #hardware.bluetooth.enable = true;

  # Video Driver
  services.xserver.videoDrivers = ["amdgpu-pro" "amdgpu"];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # AMD driver
  #services.xserver.videoDrivers = [ "ati_unfree" ];

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
      packages =
          with pkgs;[             
            # Internet
            speedtest-cli
            firefox
            unfree.google-chrome
            transmission
            transmission-gtk	
            deluge
            #deluge-gtk
	    torbrowser
	    tsocks
	    
	    gdb
	    valgrind
	    texlive.combined.scheme-full
	    haxor-news

            # Launcher
            rofi
            rofi-pass
	    gnome3.adwaita-icon-theme
            xorg.xev

	    # Text
            libreoffice
 
            # vscode
            libunwind
	    lttng-ust
	    libuuid
	    icu
	    gettext
	    zlib
	    desktop-file-utils

	    vscode
	    

            # Terminal
            kitty
	    ranger
            neofetch
            tmux
            thefuck
          
            # Media
            #vlc
            mpv
	    #youtube-dl
	    ffmpeg
            imagemagick
            ncmpcpp
            blueman
          
            # PDF
            zathura

            # WM
            compton
            polybar
            jq
	    xorg.xwininfo
	    lemonbar-xft
            #python36Packages.setuptools
	    conky
	    xdotool
	    
	    pywal
	    (python35.withPackages(ps: with ps; [ pywal ]))
	    dunst
            libnotify
	    i3lock-fancy
            lastpass-cli
            xclip
            xwinwrap
            xscreensaver
            gifsicle

            # Nix
            nix-prefetch-git

            # Games
	          unfree.steam
            hwinfo
            #Misc
            xxd
	    binutils 
	   ];
    };
    extraUsers.emily = {
      isNormalUser = true;
      uid = 1001;
      extraGroups = ["networkmanager" "audio"];
      packages =
          with pkgs;[ 
            firefox
            unfree.google-chrome
            xclip
            zathura
            libreoffice 
            transmission
            transmission-gtk
           ];
    };

    groups.media = {
      members = ["transmission" "sonarr" "radarr" "plex" "lambda"];
    };
  };


  

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}

