final: prev:

let
  linux-lto_overlay = prev.PREV.callPackage ({ stdenvNoCC, fetchurl }:

    stdenvNoCC.mkDerivation rec {
      pname = "linux-lto_overlay";
      version = "unstable-2022-03-24";

      src = fetchurl {
        url =
          "https://raw.githubusercontent.com/lovesegfault/nix-config/${passthru.rev}/nix/overlays/linux-lto.nix";
        sha256 = "169xq6h6r7fldr5v2fawjmvp5zswavrandnjym033yqvks9l74sy";
      };

      dontUnpack = true;

      installPhase = ''
        cp $src $out
        chmod +w $out

        echo '// {
          linuxKernel = _.linuxKernel // {
            ltoPackages = {
              zen = packagesFor
                (fullLTO linuxKernel.kernels.linux_zen);

              zen_skylake = packagesFor
                (cfg { MSKYLAKE = yes; } (fullLTO linuxKernel.kernels.linux_zen));

              zen_zen2 = packagesFor
                (cfg { MZEN2 = yes; } (fullLTO linuxKernel.kernels.linux_zen));
            };
          };
        }' >> $out
      '';

      passthru.rev = "58af88e66bb69c4e7727a4cf62a87a00e9ec230d";
    }) { };

in { inherit linux-lto_overlay; } // import linux-lto_overlay final prev
