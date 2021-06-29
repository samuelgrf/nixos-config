_: prev:
with prev; {

  linux_zen = linux_zen.override {
    argsOverride = rec {
      version = "5.12.13";
      modDirVersion = "${version}-zen1";

      src = fetchFromGitHub {
        owner = "zen-kernel";
        repo = "zen-kernel";
        rev = "v${modDirVersion}";
        sha256 = "sha256-rQLrC441bfknmmIR1qVvJ+x+K1xRSdmaP/QuZ1WAFqw=";
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

      extraMeta.branch = "${lib.versions.majorMinor version}/master";

      stdenv = overrideCC gccStdenv buildPackages.gcc_latest;
    };
  };

}
