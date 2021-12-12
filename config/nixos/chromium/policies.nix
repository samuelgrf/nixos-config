{ lib, stevenblack-blocklist, ... }: {

  # Enterprise policy list: https://chromeenterprise.google/policies/
  # chrome://policy shows applied policies and syntax errors.
  programs.chromium.extraOpts = {

    # Settings
    BlockThirdPartyCookies = true;
    DefaultCookiesSetting = 1;
    DefaultNotificationsSetting = 2;
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "Google";
    DefaultSearchProviderKeyword = "!g";
    DefaultSearchProviderSearchURL =
      "https://www.google.com/search?q={searchTerms}";
    DefaultSearchProviderSuggestURL =
      "https://www.google.com/complete/search?q={searchTerms}";
    DefaultSearchProviderImageURL =
      "https://www.google.com/searchbyimage/upload";
    DefaultSearchProviderImageURLPostParams =
      "encoded_image={google:imageThumbnail}";
    DefaultSearchProviderIconURL = "https://www.google.com/favicon.ico";
    HideWebStoreIcon = true;

    # uBlock Origin
    "3rdparty".extensions.cjpalhdlnbpafiamejdnhcphjbkeiagm.toOverwrite = let
      localListNames =
        __attrNames (__readDir "${stevenblack-blocklist}/extensions/porn");
      localLists =
        map (n: "file://${stevenblack-blocklist}/extensions/porn/${n}/hosts")
        localListNames;
    in {
      filterLists = [
        "user-filters"
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-abuse"
        "ublock-unbreak"
        "easylist"
        "easyprivacy"
        "urlhaus-1"
        "fanboy-annoyance"
        "ublock-annoyances"
        "plowe-0"
      ] ++ localLists;
    };

    # Pinned extensions
    ExtensionSettings = lib.genAttrs [
      "ocaahdebbfolfmndjeplogmgcagdmblk" # Chromium Web Store
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
    ] (_: { toolbar_pin = "force_pinned"; });

    # Cookie whitelist
    CookiesAllowedForUrls = [

      # Google Drive (fix downloads)
      "[*.]googleusercontent.com"

      # MS Teams (fix login)
      "assignments.onenote.com"
      "login.microsoftonline.com"
    ];
  };

  programs.chromium.enable = true;
}
