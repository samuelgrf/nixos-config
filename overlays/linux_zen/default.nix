_: prev:
with prev; {

  linuxKernel = linuxKernel // {
    kernels = linuxKernel.kernels // {

      linux_zen = let
        modDirVersion = "5.13.13-zen1";
        parts = lib.splitString "-" modDirVersion;
        version = lib.elemAt parts 0;

        numbers = lib.splitString "." version;
        branch = "${lib.elemAt numbers 0}.${lib.elemAt numbers 1}";

        argsOverride = {
          inherit version modDirVersion;

          src = fetchFromGitHub {
            owner = "zen-kernel";
            repo = "zen-kernel";
            rev = "v${modDirVersion}";
            hash = "sha256-aTTbhXy0wsDDCSbX1k27l9g3FliqwE6TbRq2zkI3mnw=";
          };

          structuredExtraConfig = with lib.kernel; {

            # Preemptive kernel
            PREEMPT = lib.mkForce yes;
            PREEMPT_VOLUNTARY = lib.mkForce no;

            # Additional CPU optimizations
            CC_OPTIMIZE_FOR_PERFORMANCE_O3 = yes;

            # BBRv2 TCP congestion control
            TCP_CONG_BBR2 = yes;
            DEFAULT_BBR2 = yes;

            # FQ-PIE packet scheduling
            NET_SCH_DEFAULT = yes;
            DEFAULT_FQ_PIE = yes;
          };

          meta = { inherit branch; };
        };

      in linuxKernel.kernels.linux_zen.override { inherit argsOverride; } // {
        passthru = { inherit argsOverride; };
      };
    };
  };

}
