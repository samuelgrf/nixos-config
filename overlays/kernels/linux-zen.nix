{ stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  version = "5.7.12";
in

buildLinux (args // {
  modDirVersion = "${version}-zen1";
  inherit version;

  src = fetchFromGitHub {
    owner = "zen-kernel";
    repo = "zen-kernel";
    rev = "v${version}-zen1";
    sha256 = "1sbm6wxlbi3bllp6fjjaj5qd0g05732shhcxwac7f48hmjgkmyfq";
  };

  extraMeta = {
    branch = "5.7/master";
    maintainers = with stdenv.lib.maintainers; [ atemu ];
  };

} // (args.argsOverride or {}))
