{

  powermanagementprofilesrc = {
    AC = {
      BrightnessControl.value = null;
      DimDisplay.idleTime = 780000; # ​    13 min
      DPMSControl.idleTime = 900; # ​      15 min
      SuspendSession.idleTime = null;
    };
    Battery = {
      BrightnessControl.value = null;
      DimDisplay.idleTime = 480000; # ​     8 min
      DPMSControl.idleTime = 600; # ​      10 min
      SuspendSession.idleTime = 900000; # ​15 min
    };
    LowBattery = {
      BrightnessControl.value = 30; # ​       30%
      DimDisplay.idleTime = 180000; # ​     3 min
      DPMSControl.idleTime = 300; # ​       5 min
      SuspendSession.idleTime = 600000; # ​10 min
    };
  };

}
