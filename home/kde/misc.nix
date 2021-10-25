{
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

  # Disable file indexing.
  baloofilerc."Basic Settings".Indexing-Enabled = false;
}
