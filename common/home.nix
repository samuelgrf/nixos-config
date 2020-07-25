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

    # Wine thinks it's an amazing idea to generate lots of .desktop files
    # everytime a new prefix is created. These make the last Wine executable
    # that was ran (including those from Steam and Lutris) the default
    # for multiple filetypes.
    associations.removed = {
      "application/pdf" = "wine-extension-pdf.desktop";
      "application/rtf" = "wine-extension-rtf.desktop";
      "application/vnd.ms-htmlhelp" = "wine-extension-chm.desktop";
      "application/winhlp" = "wine-extension-hlp.desktop";
      "application/x-ms-application" = "wine-extension-application.desktop";
      "application/x-ms-xbap" = "wine-extension-xbap.desktop";
      "application/x-mswinurl" = "wine-extension-url.desktop";
      "application/x-mswrite" = "wine-extension-wri.desktop";
      "application/x-wine-extension-appref-ms" = "wine-extension-appref-ms.desktop";
      "application/x-wine-extension-compositefont" = "wine-extension-compositefont.desktop";
      "application/x-wine-extension-crd" = "wine-extension-crd.desktop";
      "application/x-wine-extension-crds" = "wine-extension-crds.desktop";
      "application/x-wine-extension-ini" = "wine-extension-ini.desktop";
      "application/x-wine-extension-msp" = "wine-extension-msp.desktop";
      "application/x-wine-extension-vbs" = "wine-extension-vbs.desktop";
      "application/xaml+xml" = "wine-extension-xaml.desktop";
      "application/xml" = "wine-extension-xml.desktop";
      "image/gif" = "wine-extension-gif.desktop";
      "image/jpeg" = [ "wine-extension-jfif.desktop" "wine-extension-jpe.desktop" ];
      "image/png" = "wine-extension-png.desktop";
      "text/html" = "wine-extension-htm.desktop";
      "text/plain" = "wine-extension-txt.desktop";
    };
  };
}
