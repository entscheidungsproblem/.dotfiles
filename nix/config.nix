{
  allowUnfree = true;

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

    all = with pkgs; buildEnv {
      name = "all";

      paths = [
	# Internet
	speedtest-cli
      	firefox
      	unfree.google-chrome
      	transmission
      	transmission-gtk	
      	
	# Launcher
      	rofi
      	rofi-pass

	# Text
      	libreoffice

	# Terminal
      	kitty
      	ranger
      	neofetch
      	tmux
      	thefuck
      
	# Media
      	vlc
      	ffmpeg
      	imagemagick
      	ncmpcpp
      	blueman
      
      	# PDF
      	zathura

      	# WM
      	compton
      	polybar
      	lemonbar
      	pywal
      	dunst
      	i3lock-fancy
      	lastpass-cli
      	xclip
      	xwinwrap
      	xscreensaver
      	gifsicle

      	# Nix
      	nix-prefetch-git
      ];
    };
  };
}
