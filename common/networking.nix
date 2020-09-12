{ config, pkgs, ... }:

{
  # Enable NetworkManager.
  networking.networkmanager.enable = true;

  # Don't respond to IPv4 pings.
  networking.firewall.allowPing = false;

  # Open ports needed for Steam In-Home Streaming.
  # https://support.steampowered.com/kb_article.php?ref=8571-GLVN-8711
  networking.firewall.allowedTCPPorts = [ 27036 ];
  networking.firewall.allowedUDPPortRanges = [ { from = 27031; to = 27036; } ];

  # Add blocklists to hosts file.
  networking.hostFiles = with pkgs; [
    "${stevenblack-hosts-porn-extension}/share/clefspeare13"
    "${stevenblack-hosts-porn-extension}/share/sinfonietta"
    "${stevenblack-hosts-porn-extension}/share/sinfonietta-snuff"
    "${stevenblack-hosts-porn-extension}/share/tiuxo"
  ];

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

      # Google data-sharing
      AlternateErrorPagesEnabled = false;
      BrowserSignin = 0;
      ChromeVariations = 2;
      ClickToCallEnabled = false;
      # Also downloads and updates `Origin Trials`.
      ComponentUpdatesEnabled = false;
      LocalDiscoveryEnabled = false;
      MetricsReportingEnabled = false;
      PasswordLeakDetectionEnabled = false;
      PaymentMethodQueryEnabled = false;
      PrinterTypeDenyList = [ "cloud" ];
      ReportExtensionsAndPluginsData = false;
      ReportMachineIDData = false;
      ReportPolicyData = false;
      ReportUserIDData = false;
      ReportVersionData = false;
      SafeBrowsingExtendedReportingEnabled = false;
      SafeBrowsingProtectionLevel = 0;
      SendFilesForMalwareCheck = 0;
      SharedClipboardEnabled = false;
      SpellCheckServiceEnabled = false;
      SyncDisabled = true;
      TranslateEnabled = false;
      UnsafeEventsReportingEnabled = false;
      UrlKeyedAnonymizedDataCollectionEnabled = false;
      WebRtcEventLogCollectionAllowed = false;

      # Customization
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundModeEnabled = false;
      BlockThirdPartyCookies = true;
      CookiesAllowedForUrls = [ "login.microsoftonline.com" ]; # Fixes MS Teams.
      DefaultNotificationsSetting = 2;
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "DuckDuckGo";
      DefaultSearchProviderKeyword = "duckduckgo.com";
      DefaultSearchProviderIconURL = "https://duckduckgo.com/favicon.ico";
      DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
      DefaultSearchProviderSuggestURL = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
      DefaultSearchProviderNewTabURL = "https://duckduckgo.com/chrome_newtab";
      ExtensionInstallBlocklist = [ "*" ];
      ExtensionInstallAllowlist = config.programs.chromium.extensions;
      # Results in significant CPU and battery savings.
      IntensiveWakeUpThrottlingEnabled = true;
      PasswordManagerEnabled = false;
      PromotionalTabsEnabled = false;
      ShowAppsShortcutInBookmarkBar = false;
      UserFeedbackAllowed = false;

      # uBlock Origin
      "3rdparty".extensions.cjpalhdlnbpafiamejdnhcphjbkeiagm.adminSettings = ''
        ${builtins.toJSON {
          selectedFilterLists = [
            "user-filters"
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-abuse"
            "ublock-unbreak"
            "easylist"
            "easyprivacy"
            "urlhaus-1"
            "adguard-annoyance"
            "ublock-annoyances"
            "plowe-0"
          ];
          userFilters = ''
            ! Reddit: Hide 'Get Coins' button
            www.reddit.com##.jEUbSHJJx8vISKpWirlfx
            ! Reddit: Hide account information
            www.reddit.com###email-collection-tooltip-id
          '';
        }
      }'';
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
        commandLineArgs = "--ignore-gpu-blocklist --enable-gpu-rasterization \\
          --enable-oop-rasterization --enable-zero-copy \\
          --force-dark-mode --enable-features=WebUIDarkMode"
          + (if config.networking.hostName == "HPx"
             then " --force-device-scale-factor=1"
             else "");
      };
    })
  ];
}
