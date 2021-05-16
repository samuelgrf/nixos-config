{ config, kdeFrameworks, lib, ... }:

with lib;

let
  cfg = config.programs.kde;

  toString' = v: if isBool v then boolToString v else toString v;

  settingsLists = attrsets.collect isList
    (mapAttrsRecursive (path: value: path ++ [ (toString' value) ])
      cfg.settings);

  commandList = map (args:
    flatten [
      "${kdeFrameworks.kconfig}/bin/kwriteconfig5"
      "--file"
      (head args)
      (map (g: [ "--group" g ]) (sublist 1 (length args - 3) args))
      "--key"
      (last (init args))
      (last args)
    ]) settingsLists;

  commandString = concatMapStringsSep "\n" escapeShellArgs commandList;
in {

  options.programs.kde = {
    enable = mkEnableOption "KDE";

    settings = mkOption {
      default = { };
      example = literalExample ''{ kwinrc = { General.Foo = "bar"; }; }'';
      description = "KDE settings";
      type = types.attrs;
    };
  };

  config = mkIf cfg.enable {
    home.activation.kdeSettings =
      hm.dag.entryAfter [ "writeBoundary" ] commandString;
  };

}
