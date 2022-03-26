final: prev:

let
  linux-lto-overlay = prev.PREV.callPackage ({ stdenvNoCC, fetchurl }:

    stdenvNoCC.mkDerivation rec {
      pname = "linux-lto-overlay";
      version = "unstable-2022-03-25";

      src = fetchurl {
        url =
          "https://raw.githubusercontent.com/lovesegfault/nix-config/${passthru.rev}/nix/overlays/linux-lto.nix";
        sha256 = "12qlqq0b10izszgjqvbbk0jbxjk6dh4bjfckz02viw7hppp60y6d";
      };

      dontUnpack = true;

      installPhase = ''
        cp $src $out
        chmod +w $out

        echo '// {
          linuxKernel = _.linuxKernel // {
            ltoPackages = {
              linux_zen = packagesFor (fullLTO kernels.linux_zen);

              linux_zen_skylake =
                packagesFor (cfg { MSKYLAKE = yes; } (fullLTO kernels.linux_zen));

              linux_zen_zen2 =
                packagesFor (cfg { MZEN2 = yes; } (fullLTO kernels.linux_zen));
            };
          };
        }' >> $out
      '';

      passthru.rev = "7827bd81ace8fc2053257639cca8a519a3baff36";
    }) { };

in { inherit linux-lto-overlay; } // import linux-lto-overlay final prev
