{ lib }:

with builtins // lib; rec {

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

  sudoBashCmd = cmd: "sudo bash -c ${escapeShellArg cmd}";

  sudoShCmd = cmd: "sudo sh -c ${escapeShellArg cmd}";

}
