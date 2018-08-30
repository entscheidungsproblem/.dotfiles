{ config, pkgs, ... }:

{
  fonts = {
    enableDefaultFonts = true;
    enableFontDir = true;
    fonts = [
      pkgs.roboto
      pkgs.roboto-slab
      pkgs.fira-code
      pkgs.powerline-fonts
      pkgs.nerdfonts
    ];
  };
}

