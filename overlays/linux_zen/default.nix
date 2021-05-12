_: prev:
with prev;

let
  version = "5.12.2";
  suffix = "zen2";
in {

  linux_zen = linux_zen.override {
    argsOverride = {
      modDirVersion = "${version}-${suffix}";
      inherit version;

      src = fetchFromGitHub {
        owner = "zen-kernel";
        repo = "zen-kernel";
        rev = "v${version}-${suffix}";
        hash = "sha256-FPUe4+JfMAjqrst3PfAjvMRSgQHFXEpbcqHTyddIrjA=";
      };
    };
  };

}
