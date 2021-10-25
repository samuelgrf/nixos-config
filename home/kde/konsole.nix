{
  # Disable menubar.
  konsolerc.KonsoleWindow.ShowMenuBarByDefault = false;

  # Disable toolbar.
  konsolerc.MenuBar = false;

  # Theming
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
}
