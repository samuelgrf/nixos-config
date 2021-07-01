{ nixos-artwork, ... }: {

  # Configure KDE.
  programs.kde = {
    enable = true;
    settings = {

      # Set desktop wallpaper.
      "plasma-org.kde.plasma.desktop-appletsrc".Containments."1".Wallpaper."org.kde.image".General.Image =
        "file://${nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png";

      # Set lockscreen wallpaper.
      kscreenlockerrc.Greeter.Wallpaper."org.kde.image".General.Image =
        "file://${nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png";

      # Configure Konsole.
      konsolerc.KonsoleWindow.ShowMenuBarByDefault = false;
      konsolerc.MenuBar = false;
      konsolerc."Desktop Entry".DefaultProfile = "Profile 1.profile";
      "$HOME/.local/share/konsole/Profile 1.profile" = {
        Appearance.Font = "MesloLGS NF,11,-1,5,50,0,0,0,0,0";
        "Cursor Options".CursorShape = 1;
        General.Name = "Profile 1";
        General.Parent = "FALLBACK/";
        Scrolling.HistorySize = 100000;
        "Terminal Features".BlinkingCursorEnabled = true;
      };
      "$HOME/.local/share/konsole/Breeze.colorscheme" = {
        General = {
          Blur = false;
          ColorRandomization = false;
          Description = "Breeze";
          Opacity = 1;
          Wallpaper = "";
        };
        Background.Color = "0,0,0";
        BackgroundFaint.Color = "49,54,59";
        BackgroundIntense.Color = "0,0,0";
        Color0.Color = "35,38,39";
        Color0Faint.Color = "49,54,59";
        Color0Intense.Color = "127,140,141";
        Color1.Color = "237,21,21";
        Color1Faint.Color = "120,50,40";
        Color1Intense.Color = "192,57,43";
        Color2.Color = "17,209,22";
        Color2Faint.Color = "23,162,98";
        Color2Intense.Color = "28,220,154";
        Color3.Color = "246,116,0";
        Color3Faint.Color = "182,86,25";
        Color3Intense.Color = "253,188,75";
        Color4.Color = "29,153,243";
        Color4Faint.Color = "27,102,143";
        Color4Intense.Color = "61,174,233";
        Color5.Color = "155,89,182";
        Color5Faint.Color = "97,74,115";
        Color5Intense.Color = "142,68,173";
        Color6.Color = "26,188,156";
        Color6Faint.Color = "24,108,96";
        Color6Intense.Color = "22,160,133";
        Color7.Color = "252,252,252";
        Color7Faint.Color = "99,104,109";
        Color7Intense.Color = "255,255,255";
        Foreground.Color = "252,252,252";
        ForegroundFaint.Color = "239,240,241";
        ForegroundIntense.Color = "255,255,255";
      };

      # Kate: Use system color scheme.
      katerc."KTextEditor Renderer".Schema = "KDE";

      # Dolphin: Show hidden files.
      "$HOME/.local/share/dolphin/view_properties/global/.directory".Settings.HiddenFilesShown =
        true;

      # Dolphin: Don't remember last session.
      dolphinrc.General.RememberOpenedTabs = false;

      # Ark: Open destination folder after extracting.
      arkrc.Extraction.openDestinationFolderAfterExtraction = true;

      # Enable Dynamic Workspaces extension.
      kwinrc.Plugins.dynamic_workspacesEnabled = true;

      # Enable Night Color.
      kwinrc.NightColor.Active = true;

      # Set keyboard shortcuts.
      kglobalshortcutsrc = {
        kwin = {
          "Switch One Desktop to the Left" =
            "Meta+A,Meta+Ctrl+Left,Switch One Desktop to the Left";
          "Switch One Desktop to the Right" =
            "Meta+S,Meta+Ctrl+Right,Switch One Desktop to the Right";
          "stop current activity" = ",Meta+S,Stop Current Activity";
          "Window Minimize" = "Meta+Down,Meta+PgDown,Minimize Window";
          "Window Quick Tile Bottom" =
            ",Meta+Down,Quick Tile Window to the Bottom";
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

      # Set power management profiles.
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

      # Use OpenGL 3 rendering backend.
      kwinrc.Compositing.GLCore = true;

      # Disable animations.
      kdeglobals.KDE.AnimationDurationFactor = 0;
      "gtk-3.0/settings.ini".Settings.gtk-enable-animations = 0;
      "glib-2.0/settings/keyfile"."org/gnome/desktop/interface".enable-animations =
        false;

      # Disable application launch feedback.
      klaunchrc.FeedbackStyle.BusyCursor = false;
      klaunchrc.BusyCursorSettings.Bouncing = false;

      # Start with an empty session after login.
      ksmserverrc.General.loginMode = "emptySession";

      # Disable lockscreen media controls.
      kscreenlockerrc.Greeter.LnF.General.showMediaControls = false;

      # Remove help button from titlebar.
      kwinrc."org.kde.kdecoration2".ButtonsOnRight = "IAX";

      # Disable file indexing.
      baloofilerc."Basic Settings".Indexing-Enabled = false;

      # Enable natural scrolling on amethyst.
      touchpadxlibinputrc."SYNA328B:00 06CB:CD50 Touchpad".naturalScroll = true;
    };
  };

}
