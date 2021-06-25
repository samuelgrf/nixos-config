_: prev:
with prev; {

  linux_xanmod = linux_xanmod.override {
    argsOverride = {
      structuredExtraConfig = with lib.kernel; {
        PREEMPT = lib.mkForce yes;
        PREEMPT_VOLUNTARY = lib.mkForce no;
      };
    };
  };

}
