{ config, ... }:

{
  # Enable NetworkManager.
  networking.networkmanager.enable = true;

  # Open ports needed for Steam In-Home Streaming.
  # https://support.steampowered.com/kb_article.php?ref=8571-GLVN-8711
  networking.firewall.allowedTCPPorts = [ 27036 ];
  networking.firewall.allowedUDPPortRanges = [ { from = 27031; to = 27036; } ];

  # Set Chromium/Chrome configuration.
  programs.chromium = {
    enable = true;
    extensions = [
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "eekailopagacbcdloonjhbiecobagjci" # Go Back With Backspace
      "aghfnjkcakhmadgdomlmlhhaocbkloab" # Just Black (theme)
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
      "nffaoalbilbmmfgbnbgppjihopabppdk" # Video Speed Controller
    ];
    # Policy list: https://cloud.google.com/docs/chrome-enterprise/policies
    # Search provider data found in:
    # https://github.com/chromium/chromium/blob/fdb6dc24cc/components/search_engines/prepopulated_engines.json#L94
    extraOpts = {
      AlternateErrorPagesEnabled = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundModeEnabled = false;
      BlockThirdPartyCookies = true;
      BrowserSignin = 0;
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "DuckDuckGo";
      DefaultSearchProviderKeyword = "duckduckgo.com";
      DefaultSearchProviderIconURL = "https://duckduckgo.com/favicon.ico";
      DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
      DefaultSearchProviderSuggestURL = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
      DefaultSearchProviderNewTabURL = "https://duckduckgo.com/chrome_newtab";
      MetricsReportingEnabled = false;
      PasswordManagerEnabled = false;
      SafeBrowsingExtendedReportingEnabled = false;
      SafeBrowsingProtectionLevel = 0;
      SpellCheckServiceEnabled = false;
      SyncDisabled = true;
      TranslateEnabled = false;
      UrlKeyedAnonymizedDataCollectionEnabled = false;
    };
  };

  # Add command line arguments to Google Chrome.
  nixpkgs.overlays = [
    (self: super: {
      google-chrome-beta = super.google-chrome-beta.override {
        # TODO Remove `--force-device-scale-factor=1` when
        # https://bugs.chromium.org/p/chromium/issues/detail?id=1087109
        # or https://github.com/NixOS/nixpkgs/issues/89512
        # are resolved.
        commandLineArgs = "--force-device-scale-factor=1 --ignore-gpu-blacklist \\
          --enable-gpu-rasterization --enable-oop-rasterization --enable-zero-copy \\
          --force-dark-mode --enable-features=WebUIDarkMode";
      };
    })
  ];
}
