{ lib, ... }: {

  # Enable NetworkManager.
  networking.networkmanager.enable = true;

  # Don't respond to IPv4 pings.
  networking.firewall.allowPing = false;

  # Configure Chromium/Chrome.
  # Command line arguments are set in ../overlays/ungoogled-chromium.
  programs.chromium = {
    enable = true;

    # Enterprise policy list: https://chromeenterprise.google/policies/
    # chrome://policy shows applied policies and syntax errors.
    extraOpts = {

      # Settings
      BlockThirdPartyCookies = true;
      DefaultCookiesSetting = 1;
      DefaultNotificationsSetting = 2;
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "DuckDuckGo";
      DefaultSearchProviderKeyword = "duck.com";
      DefaultSearchProviderIconURL = "https://duckduckgo.com/favicon.ico";
      DefaultSearchProviderSearchURL =
        "https://duckduckgo.com/?q={searchTerms}";
      DefaultSearchProviderSuggestURL =
        "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
      HideWebStoreIcon = true;

      # uBlock Origin
      "3rdparty".extensions.cjpalhdlnbpafiamejdnhcphjbkeiagm.adminSettings = let
        externalLists = [
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/extensions/porn/clefspeare13/hosts"
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/extensions/porn/sinfonietta/hosts"
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/extensions/porn/sinfonietta-snuff/hosts"
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/extensions/porn/tiuxo/hosts"
        ];
      in __toJSON {
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
        ] ++ externalLists;
        userSettings.externalLists = lib.concatStringsSep "\n" externalLists;
        userFilters = ''
          ! Reddit: Hide 'Get Coins' button
          www.reddit.com##.jEUbSHJJx8vISKpWirlfx
          ! Reddit: Hide account information
          www.reddit.com###email-collection-tooltip-id
        '';
      };

      # Bookmarks
      ManagedBookmarks = [
        {
          name = "Manuals";
          children = [
            {
              name = "NixOS Manual";
              url = "file:///run/current-system/sw/share/doc/nixos/index.html";
            }
            {
              name = "Nixpkgs Manual";
              url =
                "file:///run/current-system/sw/share/doc/nixpkgs/manual.html";
            }
            {
              name = "Nix Manual";
              url =
                "file:///run/current-system/sw/share/doc/nix/manual/index.html";
            }
          ];
        }
        {
          name = "Extensions";
          children = [
            {
              name = "Extensions";
              url = "chrome://extensions";
            }
            {
              name = "Chromium Web Store";
              url = "https://github.com/NeverDecaf/chromium-web-store/releases";
            }
          ] ++ lib.mkWebstoreBookmarks {
            "Dark Reader" = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
            "Go Back with Backspace" = "eekailopagacbcdloonjhbiecobagjci";
            "Just Black" = "aghfnjkcakhmadgdomlmlhhaocbkloab";
            "Not yet, AV1" = "dcmllfkiihingappljlkffafnlhdpbai";
            "SponsorBlock" = "mnjggcdmjocbbbhaepdhchncahnbgone";
            "uBlock Origin" = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
            "Video Speed Controller" = "nffaoalbilbmmfgbnbgppjihopabppdk";
          };
        }
      ];

      # MS Teams
      CookiesAllowedForUrls =
        [ "assignments.onenote.com" "login.microsoftonline.com" ];
    };
  };

}
