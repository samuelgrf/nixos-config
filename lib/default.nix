{ lib, pkgs }:

with builtins // lib; rec {

  /* Example:
       formatDateSep "-" "20210619"
       => 2021-06-19
  */
  formatDateSep = s: d:
    concatStringsSep s [
      (substring 0 4 d)
      (substring 4 2 d)
      (substring 6 2 d)
    ];

  /* Like toString, but converts booleans to "true" or "false"
     instead of "1" or "".
  */
  toString' = v: if isBool v then boolToString v else toString v;

  mkHostId = s: substring 0 8 (hashString "sha256" s);

  mkSystemdScript = name: text:
    let
      out = pkgs.writeTextFile {
        # The derivation name is different from the script file name
        # to keep the script file name short to avoid cluttering logs.
        name = "unit-script-${name}";
        executable = true;
        destination = "/bin/${name}";
        text = ''
          #!${pkgs.runtimeShell} -e
          ${text}
        '';
        checkPhase = ''
          ${pkgs.stdenv.shell} -n "$out/bin/${name}"
        '';
      };
    in "${out}/bin/${name}";

  mkGreasyforkUrl = name: id:
    "https://greasyfork.org/scripts/${toString id}/code/${
      replaceStrings [ "/" ] [ "" ] name
    }.user.js";

  mkGreasyforkBookmarks = mapAttrsToList (name: id: {
    inherit name;
    url = mkGreasyforkUrl name id;
  });

  mkWebstoreUrl = id:
    "javascript:location.href="
    + "'https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3'"
    + "+'&prodversion='+(navigator.appVersion.match(/Chrome\\/(\\S+)/)[1])"
    + "+'&x=id%'+'3D'+'${id}'+'%'+'26installsource%'+'3Dondemand%'+'26uc'";

  mkWebstoreBookmarks = mapAttrsToList (name: id: {
    inherit name;
    url = mkWebstoreUrl id;
  });

}
