{ pkgs, ... }:

{
  # Set system-wide fonts.
  fonts.fonts = with pkgs; [
    liberation_ttf # Free replacement for MS Fonts.
    nerdfonts.hack # Emacs
    nerdfonts.meslo-lg
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  # Set default fonts.
  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      "Noto Sans"
    ];
    serif = [
      "Noto Serif"
    ];
    monospace = [
      "MesloLGS Nerd Font"
      "Noto Sans Mono"
    ];
    emoji = [
      "Noto Color Emoji"
    ];
  };
}
