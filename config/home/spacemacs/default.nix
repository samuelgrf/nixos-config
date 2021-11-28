{ lib, spacemacs, ... }: {

  home.file = {
    ".spacemacs".source = ./.spacemacs;

  } // (with lib;
    let
      spacemacsDirs = __readDir spacemacs;
      mapDirs = name: _:
        nameValuePair ".emacs.d/${name}" {
          recursive = name == "private" || name == "layers";
          source = "${spacemacs}/${name}";
        };
    in mapAttrs' mapDirs spacemacsDirs);
}
