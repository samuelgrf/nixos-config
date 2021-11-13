{ spacemacs, ... }: {

  home.file = {
    ".emacs.d" = {
      source = spacemacs;
      recursive = true;
    };

    ".spacemacs".source = ./.spacemacs;
  };
}
