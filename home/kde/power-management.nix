let
  minToSec = __mul 60;
  minToMsec = __mul 60000;
in {

  powermanagementprofilesrc = {
    AC = {
      BrightnessControl.value = null;
      DimDisplay.idleTime = minToMsec 13;
      DPMSControl.idleTime = minToSec 15;
      SuspendSession.idleTime = null;
    };

    Battery = {
      BrightnessControl.value = null;
      DimDisplay.idleTime = minToMsec 8;
      DPMSControl.idleTime = minToSec 10;
      SuspendSession.idleTime = minToMsec 15;
    };

    LowBattery = {
      BrightnessControl.value = 30;
      DimDisplay.idleTime = minToMsec 3;
      DPMSControl.idleTime = minToSec 5;
      SuspendSession.idleTime = minToMsec 10;

      # Hibernate instead of sleeping.
      HandleButtonEvents.lidAction = 2;
      SuspendSession.suspendType = 2;
    };
  };

}
