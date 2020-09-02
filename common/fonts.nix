{ config, pkgs, ... }:

{
  # Set system-wide fonts.
  fonts.fonts = with pkgs; [
    unstable.hack_nerdfont # Emacs, TODO Remove "unstable." on 20.09.
    liberation_ttf # Free replacement for MS Fonts.
    unstable.meslo-lg_nerdfont # TODO Remove "unstable." on 20.09.
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
