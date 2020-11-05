{ ... }:

{
  # The NixOS release to be compatible with for stateful data such as databases.
  # Read the release notes before changing this.
  home.stateVersion = "20.09";

  # Set Git configuration.
  programs.git = {
    enable = true;
    userName = "Samuel Gräfenstein";
    userEmail = "git@samuelgrf.com";
    signing.key = "FF2458328FAF466018C6186EEF76A063F15C63C8";
    signing.signByDefault = true;
    extraConfig = {
      pull.ff = "only";
      core.pager = "delta";
      delta = {
        line-numbers = true;
        side-by-side = true;
      };
    };
  };

  # Set mpv configuration.
  programs.mpv = {
    enable = true;
    config.keep-open = true; # Keep mpv open after playback is finished.
    config.ytdl-format = # Prefer VP9 and Opus codecs for youtube-dl streams.
      "(bestvideo[vcodec=vp9]/bestvideo)+(bestaudio[acodec=opus]/bestaudio)/best";
  };

  # Set default applications.
  xdg.mimeApps = let

    # Applications
    chromium = "chromium-browser.desktop";
    gwenview = "org.kde.gwenview.desktop";
    kate = "org.kde.kate.desktop";

    # Formats
    html = "text/html";
    http = "x-scheme-handler/http";
    https = "x-scheme-handler/https";
    ini = "application/x-wine-extension-ini";
    svg = "image/svg+xml";
    txt = "text/plain";
    url = "application/x-mswinurl";
    xhtml = "application/xhtml+xml";
    xml = "application/xml";

  in {
    enable = true;
    associations.added = {
      ${ini} = kate;
      ${svg} = gwenview;
      ${url} = kate;
      ${xml} = kate;
    };
    defaultApplications = {
      ${html} = chromium;
      ${http} = chromium;
      ${https} = chromium;
      ${ini} = kate;
      ${svg} = gwenview;
      ${txt} = kate;
      ${url} = kate;
      ${xhtml} = chromium;
      ${xml} = kate;
    };

    # Wine thinks it's an amazing idea to generate lots of .desktop files
    # everytime a new prefix is created. These make the last Wine executable
    # that was ran (including those from Steam and Lutris) the default
    # for multiple filetypes.
    associations.removed = {
      ${html} = "wine-extension-htm.desktop";
      ${ini} = "wine-extension-ini.desktop";
      ${txt} = "wine-extension-txt.desktop";
      ${url} = "wine-extension-url.desktop";
      ${xml} = "wine-extension-xml.desktop";
      "application/pdf" = "wine-extension-pdf.desktop";
      "application/rtf" = "wine-extension-rtf.desktop";
      "application/vnd.ms-htmlhelp" = "wine-extension-chm.desktop";
      "application/winhlp" = "wine-extension-hlp.desktop";
      "application/x-ms-application" = "wine-extension-application.desktop";
      "application/x-ms-xbap" = "wine-extension-xbap.desktop";
      "application/x-mswrite" = "wine-extension-wri.desktop";
      "application/x-wine-extension-appref-ms" = "wine-extension-appref-ms.desktop";
      "application/x-wine-extension-compositefont" = "wine-extension-compositefont.desktop";
      "application/x-wine-extension-crd" = "wine-extension-crd.desktop";
      "application/x-wine-extension-crds" = "wine-extension-crds.desktop";
      "application/x-wine-extension-msp" = "wine-extension-msp.desktop";
      "application/x-wine-extension-vbs" = "wine-extension-vbs.desktop";
      "application/xaml+xml" = "wine-extension-xaml.desktop";
      "image/gif" = "wine-extension-gif.desktop";
      "image/jpeg" = [ "wine-extension-jfif.desktop" "wine-extension-jpe.desktop" ];
      "image/png" = "wine-extension-png.desktop";
    };
  };
}
