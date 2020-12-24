{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.kde;

  settingsLists = attrsets.collect isList
    (mapAttrsRecursive (p: v: p ++ [v]) cfg.config);

  commandList = map
    (v: ''
      ${pkgs.kdeFrameworks.kconfig}/bin/kwriteconfig5 \
        --file "${head v}" \
        ${toString (map (v: "--group \"${v}\"") (sublist 1 (length v - 3) v))} \
        --key "${elemAt (reverseList v) 1}" \
        "${if isBool (last v) then boolToString (last v) else toString (last v)}"
    '')
    settingsLists;

  commandString = concatStrings commandList;
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
