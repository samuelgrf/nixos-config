{ lib, pkgs }:

with builtins // lib;

let
  bash = "${pkgs.bash}/bin/bash";
  sh = "${pkgs.bash}/bin/sh";
  zsh = "${pkgs.zsh}/bin/zsh";
in rec {

  mkHostId = s: substring 0 8 (hashString "sha256" s);

  mkWebstoreUrl = id:
    "javascript:location.href="
    + "'https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3'"
    + "+'&prodversion='+(navigator.appVersion.match(/Chrome\\/(\\S+)/)[1])"
    + "+'&x=id%'+'3D'+'${id}'+'%'+'26installsource%'+'3Dondemand%'+'26uc'";

  mkWebstoreBookmarks = mapAttrsToList (name: id: {
    inherit name;
    url = mkWebstoreUrl id;
  });

  sudoBashCmd = cmd: "sudo ${bash} -c ${escapeShellArg cmd}";

  sudoShCmd = cmd: "sudo ${sh} -c ${escapeShellArg cmd}";

  sudoZshICmd = cmd: "sudo ${zsh} -ic ${escapeShellArg cmd}";

  /* Like toString, but converts booleans to "true" or "false"
     instead of "1" or "".
  */
  toString' = v: if isBool v then boolToString v else toString v;

}
