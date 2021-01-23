{ pkgs, unstable, ... }:

{
  # Set system-wide fonts.
  fonts.fonts = with pkgs; [
    # TODO Remove "unstable." on 21.03.
    unstable.meslo-lgs-nf
    noto-fonts-cjk
  ];
}
