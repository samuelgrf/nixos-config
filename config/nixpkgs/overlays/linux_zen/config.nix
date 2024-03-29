_final: prev:
with prev; {

  linuxKernel = linuxKernel // {
    kernels = linuxKernel.kernels // {

      linux_zen = let
        argsOverride =
          linuxKernel.kernels.linux_zen.passthru.argsOverride or { } // {
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

              # Disable debug options
              DEBUG_KERNEL = lib.mkForce no;
              DEBUG_DEVRES = lib.mkForce (option no);
              DEBUG_INFO = lib.mkForce (option no);
              DEBUG_STACK_USAGE = lib.mkForce (option no);
              DETECT_HUNG_TASK = lib.mkForce (option no);
              RCU_TORTURE_TEST = lib.mkForce (option no);
              SCHEDSTATS = lib.mkForce (option no);
              SCHED_DEBUG = lib.mkForce (option no);
            };
          };

      in linuxKernel.kernels.linux_zen.override { inherit argsOverride; } // {
        passthru = { inherit argsOverride; };
      };
    };
  };
}
