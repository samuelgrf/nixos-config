_: prev:
with prev;

let
  version = "5.12.5";
  suffix = "zen1";
in {

  linux_zen = linux_zen.override {
    argsOverride = {
      modDirVersion = "${version}-${suffix}";
      inherit version;

      src = fetchFromGitHub {
        owner = "zen-kernel";
        repo = "zen-kernel";
        rev = "v${version}-${suffix}";
        hash = "sha256-KF/t6CRK/0MbVV4mf1OIrOhWMUyp5c9U/Uo0HZ2B9Ao=";
      };
    };
  };

}
