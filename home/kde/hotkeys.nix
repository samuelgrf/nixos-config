{

  kglobalshortcutsrc = {
    kwin = {
      "Switch One Desktop to the Left" =
        "Meta+A,Meta+Ctrl+Left,Switch One Desktop to the Left";
      "Switch One Desktop to the Right" =
        "Meta+S,Meta+Ctrl+Right,Switch One Desktop to the Right";
      "stop current activity" = ",Meta+S,Stop Current Activity";
      "Window Minimize" = "Meta+Down,Meta+PgDown,Minimize Window";
      "Window Quick Tile Bottom" = ",Meta+Down,Quick Tile Window to the Bottom";
      "Window Maximize" = "Meta+Up,Meta+PgUp,Maximize Window";
      "Window Quick Tile Top" = ",Meta+Up,Quick Tile Window to the Top";
      "Window One Desktop to the Left" =
        "Meta+Shift+A,none,Window One Desktop to the Left";
      "Window One Desktop to the Right" =
        "Meta+Shift+S,none,Window One Desktop to the Right";
    };
    kded5."Show System Activity" = ",Ctrl+Esc,Show System Activity";
    khotkeys."{f3242e9b-1c88-455f-be32-f9d50105551a}" =
      "Ctrl+Esc,none,Launch KSysGuard";
  };

  khotkeysrc = {
    Data.DataCount = 4;
    Data_4.Comment = "";
    Data_4.Enabled = true;
    Data_4.Name = "Launch KSysGuard";
    Data_4.Type = "SIMPLE_ACTION_DATA";
    Data_4Actions.ActionsCount = 1;
    Data_4Actions0.CommandURL = "ksysguard";
    Data_4Actions0.Type = "COMMAND_URL";
    Data_4Conditions.Comment = "";
    Data_4Conditions.ConditionsCount = 0;
    Data_4Triggers.Comment = "Simple_action";
    Data_4Triggers.TriggersCount = 1;
    Data_4Triggers0.Key = "Ctrl+Esc";
    Data_4Triggers0.Type = "SHORTCUT";
    Data_4Triggers0.Uuid = "{f3242e9b-1c88-455f-be32-f9d50105551a}";
  };

}
