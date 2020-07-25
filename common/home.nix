{ config, lib, ... }:

{
  # Import host configuration if it exists.
  imports = if lib.pathExists ../host/home.nix then [ ../host/home.nix ] else [ ];

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

    # Applications
    kate = "org.kde.kate.desktop";
    firefox = "firefox.desktop";
    gwenview = "org.kde.gwenview.desktop";

    # Formats
    http = "x-scheme-handler/http";
    https = "x-scheme-handler/https";
    html = "text/html";
    svg = "image/svg+xml";
    txt = "text/plain";
    xml = "application/xml";
    xhtml = "application/xhtml+xml";
  in {
    enable = true;

    associations.added = {
      ${svg} = gwenview;
      ${xml} = kate;
    };
    defaultApplications = {
      ${html} = firefox;
      ${http} = firefox;
      ${https} = firefox;
      ${svg} = gwenview;
      ${txt} = kate;
      ${xhtml} = firefox;
      ${xml} = kate;
    };
  };
}
