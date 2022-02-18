{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.kde;

  settingsLists = attrsets.collect isList
    (mapAttrsRecursive (path: value: path ++ [ value ]) cfg.settings);

  commandList = map (args:
    flatten [
      "${pkgs.plasma5Packages.kconfig}/bin/kwriteconfig5"
      "--file"
      (head args)
      (map (g: [ "--group" g ]) (sublist 1 (length args - 3) args))
      "--key"
      (last (init args))
      (if last args == null then "--delete" else toString' (last args))
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
