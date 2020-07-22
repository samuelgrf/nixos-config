{ config, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  # Read the release notes before changing this.
  home.stateVersion = "20.03";

  # Set Git configuration.
  programs.git = {
    enable = true;
    userName = "Samuel Gräfenstein";
    userEmail = "git@samuelgrf.com";
    signing.key = "FF2458328FAF466018C6186EEF76A063F15C63C8";
    signing.signByDefault = true;
  };

  # Set default applications.
  xdg.mimeApps = let
    kate = "org.kde.kate.desktop";
    firefox = "firefox.desktop";
    gwenview = "org.kde.gwenview.desktop";
  in {
    enable = true;
    associations.added = {
      "application/xml" = "${kate}";

      "image/svg+xml" = "${gwenview}";
    };
    defaultApplications = {
      "application/xhtml+xml" = "${firefox}";
      "application/xml" = "${kate}";

      "image/svg+xml" = "${gwenview}";

      "text/html" = "${firefox}";
      "text/plain" = "${kate}";

      "x-scheme-handler/http" = "${firefox}";
      "x-scheme-handler/https" = "${firefox}";
    };
  };
}
