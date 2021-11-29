{ flakes, lib, ... }: {

  home.file = {
    ".spacemacs".source = ./.spacemacs;

  } // (with lib;
    let
      spacemacs = flakes.spacemacs;
      spacemacsDirs = __readDir spacemacs;
      mapDirs = name: _:
        nameValuePair ".emacs.d/${name}" {
          recursive = name == "private" || name == "layers";
          source = "${spacemacs}/${name}";
        };
    in mapAttrs' mapDirs spacemacsDirs);
}
