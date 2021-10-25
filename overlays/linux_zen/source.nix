_: prev:
with prev; {

  linuxKernel = linuxKernel // {
    kernels = linuxKernel.kernels // {

      linux_zen = if (linuxKernel.packagesFor
        linuxKernel.kernels.linux_zen).zfsStable.meta.broken then
        let
          modDirVersion = "5.13.13-zen1";

          parts = lib.splitString "-" modDirVersion;
          version = lib.elemAt parts 0;
          numbers = lib.splitString "." version;
          branch = "${lib.elemAt numbers 0}.${lib.elemAt numbers 1}";

          argsOverride =
            (linuxKernel.kernels.linux_zen.passthru.argsOverride or { }) // {
              inherit version modDirVersion;

              src = fetchFromGitHub {
                owner = "zen-kernel";
                repo = "zen-kernel";
                rev = "v${modDirVersion}";
                hash = "sha256-aTTbhXy0wsDDCSbX1k27l9g3FliqwE6TbRq2zkI3mnw=";
              };

              meta = { inherit branch; };
            };

        in linuxKernel.kernels.linux_zen.override { inherit argsOverride; } // {
          passthru = { inherit argsOverride; };
        }
      else
        linuxKernel.kernels.linux_zen;
    };
  };
}
