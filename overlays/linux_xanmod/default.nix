_: prev:
with prev; {

  linux_xanmod = linux_xanmod.override {
    argsOverride = {
      structuredExtraConfig = with lib.kernel; {

        # Preemptive Full Tickless Kernel at 500Hz
        PREEMPT_VOLUNTARY = lib.mkForce no;
        PREEMPT = lib.mkForce yes;
        NO_HZ_FULL = yes;
        HZ_500 = yes;

        # Google's Multigenerational LRU Framework
        LRU_GEN = yes;
        LRU_GEN_ENABLED = yes;

        # Google's BBRv2 TCP congestion Control
        TCP_CONG_BBR2 = yes;
        DEFAULT_BBR2 = yes;

        # FQ-PIE Packet Scheduling
        NET_SCH_DEFAULT = yes;
        DEFAULT_FQ_PIE = yes;

        # Graysky's additional CPU optimizations
        CC_OPTIMIZE_FOR_PERFORMANCE_O3 = yes;

        # Android Ashmem and Binder IPC Driver as module for Anbox
        ASHMEM = module;
        ANDROID = yes;
        ANDROID_BINDER_IPC = module;
        ANDROID_BINDERFS = module;
        ANDROID_BINDER_DEVICES = freeform "binder,hwbinder,vndbinder";
      };
    };
  };

}
