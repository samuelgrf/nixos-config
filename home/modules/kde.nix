{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.kde;

  settingsLists = attrsets.collect isList
    (mapAttrsRecursive (p: v: p ++ [v]) cfg.config);

  commandList = map
    (v:
      [ "${pkgs.kdeFrameworks.kconfig}/bin/kwriteconfig5" ] ++
      # File
      [ "--file" ] ++ [ "\"${head v}\"" ] ++
      # Groups
      map (v: "--group " + "\"${v}\"")  (sublist 1 (length v - 3) v) ++
      # Key
      [ "--key" ] ++ [ "\"${elemAt (reverseList v) 1}\"" ] ++
      # Value
      [ "\"${
        if isBool (elemAt (reverseList v) 0)
        then boolToString (elemAt (reverseList v) 0)
        else toString (elemAt (reverseList v) 0)
      }\"" ]
    )
    settingsLists;

  commandString = toString (flatten (map (v: v ++ [ "\n" ]) commandList));
in
{
  options.programs.kde = {
    enable = mkEnableOption "KDE";

    config = mkOption {
      default = { };
      example = literalExample ''{ kwinrc = { General.Foo = "bar"; }; }'';
      description = "KDE settings";
      type = types.attrs;
    };
  };

  config = mkIf cfg.enable {
    home.activation.kdeConfig = hm.dag.entryAfter [ "writeBoundary" ] commandString;
  };
}
