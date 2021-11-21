final:
let
  inherit (final) lib;

  stdenvLLVM = let
    hostLLVM = final.buildPackages.llvmPackages_13.override {
      bootBintools = null;
      bootBintoolsNoLibc = null;
    };
    buildLLVM = final.llvmPackages_13.override {
      bootBintools = null;
      bootBintoolsNoLibc = null;
    };

    mkLLVMPlatform = platform:
      platform // {
        useLLVM = true;
        linux-kernel = platform.linux-kernel // {
          makeFlags = (platform.linux-kernel.makeFlags or [ ]) ++ [
            "LLVM=1"
            "LLVM_IAS=1"
            "CC=${buildLLVM.clangUseLLVM}/bin/clang"
            "LD=${buildLLVM.lld}/bin/ld.lld"
            "HOSTLD=${hostLLVM.lld}/bin/ld.lld"
            "AR=${buildLLVM.llvm}/bin/llvm-ar"
            "HOSTAR=${hostLLVM.llvm}/bin/llvm-ar"
            "NM=${buildLLVM.llvm}/bin/llvm-nm"
            "STRIP=${buildLLVM.llvm}/bin/llvm-strip"
            "OBJCOPY=${buildLLVM.llvm}/bin/llvm-objcopy"
            "OBJDUMP=${buildLLVM.llvm}/bin/llvm-objdump"
            "READELF=${buildLLVM.llvm}/bin/llvm-readelf"
            "HOSTCC=${hostLLVM.clangUseLLVM}/bin/clang"
            "HOSTCXX=${hostLLVM.clangUseLLVM}/bin/clang++"
          ];
        };
      };

    stdenvClangUseLLVM = final.overrideCC hostLLVM.stdenv hostLLVM.clangUseLLVM;

    stdenvPlatformLLVM = stdenvClangUseLLVM.override (old: {
      hostPlatform = mkLLVMPlatform old.hostPlatform;
      buildPlatform = mkLLVMPlatform old.buildPlatform;
    });

  in stdenvPlatformLLVM // {
    passthru = (stdenvPlatformLLVM.passthru or { }) // {
      llvmPackages = buildLLVM;
    };
  };

  linuxLTOFor = { kernel, extraConfig ? { } }:
    let
      inherit (lib.kernel) yes no;
      stdenv = stdenvLLVM;
      buildPackages = final.buildPackages // { inherit stdenv; };

    in kernel.override {
      inherit stdenv buildPackages;
      argsOverride = (kernel.passthru.argsOverride or { }) // {
        structuredExtraConfig = kernel.structuredExtraConfig // {
          LTO_CLANG_FULL = yes;
          LTO_NONE = no;
        } // extraConfig;
      };
    };

  linuxLTOPackagesFor = args: final.linuxKernel.packagesFor (linuxLTOFor args);

in _: {
  linuxLTOPackages_zen =
    linuxLTOPackagesFor { kernel = final.linuxKernel.kernels.linux_zen; };

  linuxLTOPackages_zen_skylake = linuxLTOPackagesFor {
    kernel = final.linuxKernel.kernels.linux_zen;
    extraConfig = { MSKYLAKE = lib.kernel.yes; };
  };

  linuxLTOPackages_zen_zen2 = linuxLTOPackagesFor {
    kernel = final.linuxKernel.kernels.linux_zen;
    extraConfig = { MZEN2 = lib.kernel.yes; };
  };
}
