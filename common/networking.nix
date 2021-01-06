{ config, ... }:

{
  # Enable NetworkManager.
  networking.networkmanager.enable = true;

  # Don't respond to IPv4 pings.
  networking.firewall.allowPing = false;

  # Open ports needed for Steam In-Home Streaming.
  # https://support.steampowered.com/kb_article.php?ref=8571-GLVN-8711
  networking.firewall.allowedTCPPorts = [ 27036 ];
  networking.firewall.allowedUDPPortRanges = [ { from = 27031; to = 27036; } ];

  # Set Chromium/Chrome configuration.
  programs.chromium = {
    enable = true;

    # Enterprise policy list: https://cloud.google.com/docs/chrome-enterprise/policies
    # chrome://policy shows applied policies and syntax errors.
    extraOpts = {

      # Settings
      CookiesAllowedForUrls = [ "login.microsoftonline.com" ]; # Fixes MS Teams.
      DefaultCookiesSetting = 1;
      DefaultNotificationsSetting = 2;
      DefaultSearchProviderEnabled = true;
      DefaultSearchProviderName = "DuckDuckGo";
      DefaultSearchProviderKeyword = "duck.com";
      DefaultSearchProviderIconURL = "https://duckduckgo.com/favicon.ico";
      DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
      DefaultSearchProviderSuggestURL = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
      HideWebStoreIcon = true;
      # Results in significant CPU and battery savings.
      IntensiveWakeUpThrottlingEnabled = true;

      # uBlock Origin
      "3rdparty".extensions.cjpalhdlnbpafiamejdnhcphjbkeiagm.adminSettings = let
        externalLists = [
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/extensions/porn/clefspeare13/hosts"
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/extensions/porn/sinfonietta/hosts"
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/extensions/porn/sinfonietta-snuff/hosts"
          "https://raw.githubusercontent.com/StevenBlack/hosts/master/extensions/porn/tiuxo/hosts"
        ];
      in "${builtins.toJSON {
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
        userSettings.externalLists = builtins.concatStringsSep "\n" externalLists;
        userFilters = ''
          ! Reddit: Hide 'Get Coins' button
          www.reddit.com##.jEUbSHJJx8vISKpWirlfx
          ! Reddit: Hide account information
          www.reddit.com###email-collection-tooltip-id
        '';
      }}";

      # Bookmarks for installing extensions
      ManagedBookmarks = let
        mkExtUrl = extId:
          "javascript:location.href="
          + "'https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3'"
          + "+'&prodversion='+(navigator.appVersion.match(/Chrome\\/(\\S+)/)[1])"
          + "+'&x=id%'+'3D'+'${extId}'"
          + "+'%'+'26installsource%'+'3Dondemand%'+'26uc'";
      in [
        { toplevel_name = "Extensions"; }

        { name = "Chromium Web Store";
          url = "https://github.com/NeverDecaf/chromium-web-store/releases";
        }
        { name = "Dark Reader";
          url = mkExtUrl "eimadpbcbfnmbkopoojfekhnkhdbieeh";
        }
        { name = "Go Back with Backspace";
          url = mkExtUrl "eekailopagacbcdloonjhbiecobagjci";
        }
        { name = "Just Black";
          url = mkExtUrl "aghfnjkcakhmadgdomlmlhhaocbkloab";
        }
        { name = "Not yet, AV1";
          url = mkExtUrl "dcmllfkiihingappljlkffafnlhdpbai";
        }
        { name = "SponsorBlock";
          url = mkExtUrl "mnjggcdmjocbbbhaepdhchncahnbgone";
        }
        { name = "uBlock Origin";
          url = mkExtUrl "cjpalhdlnbpafiamejdnhcphjbkeiagm";
        }
        { name = "Video Speed Controller";
          url = mkExtUrl "nffaoalbilbmmfgbnbgppjihopabppdk";
        }
      ];
    };
  };
}
