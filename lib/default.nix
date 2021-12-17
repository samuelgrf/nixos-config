{ lib }:

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

  # TODO Remove once https://github.com/NixOS/nixpkgs/pull/138418 is merged.
  # Get the path to a package's main executable.
  mainProgram = pkg:
    "${getBin pkg}/bin/${pkg.meta.mainProgram or (getName pkg)}";

  mkHostId = s: substring 0 8 (hashString "sha256" s);

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
