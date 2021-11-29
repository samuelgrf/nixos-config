{ flakes, ... }: {

  home.file = {
    ".spacemacs".source = ./.spacemacs;

    ".emacs.d".source = flakes.spacemacs;
    ".emacs.d".recursive = true;
  };
}
