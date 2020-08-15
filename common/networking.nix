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
    # Official policy list (incomplete): https://cloud.google.com/docs/chrome-enterprise/policies
    # Look here for a complete up-to-date list:
    # https://source.chromium.org/chromium/chromium/src/+/master:components/policy/resources/policy_templates.json
    # Note: Policies in here are tagged based on what they do, there's also
    # the `google-sharing` tag, which as the name suggests includes options
    # that share data with Google, though it seems like that tag is not set
    # for all the offending options.
    # chrome://policy shows policies that have been/can be applied and also
    # shows syntax errors.
    # Search provider data found in:
    # https://source.chromium.org/chromium/chromium/src/+/master:components/search_engines/prepopulated_engines.json?q=prepopulated_engines.json
    extraOpts = {
      AlternateErrorPagesEnabled = false;
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundModeEnabled = false;
      BlockThirdPartyCookies = true;
      BrowserSignin = 0;
      ClickToCallEnabled = false;
      # Also downloads and updates `Origin Trials`.
      ComponentUpdatesEnabled = false;
      DefaultNotificationsSetting = 2;
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "DuckDuckGo";
      DefaultSearchProviderKeyword = "duckduckgo.com";
      DefaultSearchProviderIconURL = "https://duckduckgo.com/favicon.ico";
      DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
      DefaultSearchProviderSuggestURL = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
      DefaultSearchProviderNewTabURL = "https://duckduckgo.com/chrome_newtab";
      # Results in significant CPU and battery savings.
      IntensiveWakeUpThrottlingEnabled = true;
      LocalDiscoveryEnabled = false;
      MetricsReportingEnabled = false;
      PasswordLeakDetectionEnabled = false;
      PasswordManagerEnabled = false;
      PaymentMethodQueryEnabled = false;
      PrinterTypeDenyList = [ "cloud" ];
      PromotionalTabsEnabled = false;
      ReportExtensionsAndPluginsData = false;
      ReportMachineIDData = false;
      ReportPolicyData = false;
      ReportUserIDData = false;
      ReportVersionData = false;
      SafeBrowsingExtendedReportingEnabled = false;
      SafeBrowsingProtectionLevel = 0;
      SendFilesForMalwareCheck = 0;
      SharedClipboardEnabled = false;
      ShowAppsShortcutInBookmarkBar = false;
      SpellCheckServiceEnabled = false;
      SyncDisabled = true;
      TranslateEnabled = false;
      UnsafeEventsReportingEnabled = false;
      UrlKeyedAnonymizedDataCollectionEnabled = false;
      UserFeedbackAllowed = false;
      WebRtcEventLogCollectionAllowed = false;
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
