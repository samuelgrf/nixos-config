_: prev:
with prev; {

  linuxKernel = linuxKernel // {
    kernels = linuxKernel.kernels // {

      linux_zen = if (linuxKernel.packagesFor
        linuxKernel.kernels.linux_zen).zfsStable.meta.broken then
        with lib;
        let
          modDirVersion = "5.14.16-zen1";

          parts = splitString "-" modDirVersion;
          version = elemAt parts 0;
          numbers = splitString "." version;
          branch = "${elemAt numbers 0}.${elemAt numbers 1}";

          argsOverride =
            linuxKernel.kernels.linux_zen.passthru.argsOverride or { } // {
              inherit version modDirVersion;

              src = fetchFromGitHub {
                owner = "zen-kernel";
                repo = "zen-kernel";
                rev = "v${modDirVersion}";
                hash = "sha256-FxmhcWJd+hjekd0/98FSE35vEk9XmqIeAEAE0icFYtk=";
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
