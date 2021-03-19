{

  # Set default applications.
  xdg.dataFile."applications/mimeapps.list".force = true;
  xdg.mimeApps = let

    # Applications
    chromium = "chromium-browser.desktop";
    gimp = "gimp.desktop";
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
    xcf = "image/x-xcf";
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
      ${xcf} = gimp;
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
      "application/x-wine-extension-appref-ms" =
        "wine-extension-appref-ms.desktop";
      "application/x-wine-extension-compositefont" =
        "wine-extension-compositefont.desktop";
      "application/x-wine-extension-crd" = "wine-extension-crd.desktop";
      "application/x-wine-extension-crds" = "wine-extension-crds.desktop";
      "application/x-wine-extension-msp" = "wine-extension-msp.desktop";
      "application/x-wine-extension-vbs" = "wine-extension-vbs.desktop";
      "application/xaml+xml" = "wine-extension-xaml.desktop";
      "image/gif" = "wine-extension-gif.desktop";
      "image/jpeg" =
        [ "wine-extension-jfif.desktop" "wine-extension-jpe.desktop" ];
      "image/png" = "wine-extension-png.desktop";
    };
  };

}
