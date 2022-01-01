{ lib, ... }: [

  {
    name = "Extensions";
    children = [
      {
        name = "Extensions";
        url = "chrome://extensions";
      }
      {
        name = "Chromium Web Store";
        url =
          "https://github.com/NeverDecaf/chromium-web-store/releases/latest/download/Chromium.Web.Store.crx";
      }

    ] ++ lib.mkWebstoreBookmarks {
      "Bangs for Google" = "emidbfgmfdphfdldbmehojiocmljfonj";
      "Dark Reader" = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
      "Go Back with Backspace" = "eekailopagacbcdloonjhbiecobagjci";
      "Just Black" = "aghfnjkcakhmadgdomlmlhhaocbkloab";
      "Not yet, AV1" = "dcmllfkiihingappljlkffafnlhdpbai";
      "Redirector" = "ocgpenflpmgnfapjedencafcfakcekcd";
      "SponsorBlock" = "mnjggcdmjocbbbhaepdhchncahnbgone";
      "uBlock Origin" = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
      "Video Speed Controller" = "nffaoalbilbmmfgbnbgppjihopabppdk";
      "Violentmonkey" = "jinjaccalgkegednnccohejagnlnfdag";
    };
  }
  {
    name = "Userscripts";
    children = [{
      name = "Return YouTube Dislike";
      url =
        "https://github.com/Anarios/return-youtube-dislike/raw/main/Extensions/UserScript/Return%20Youtube%20Dislike.user.js";

    }] ++ lib.mkGreasyforkBookmarks {
      "Default YouTube to Dark Theme" = 408542;
      "Display remaining Youtube playlist time" = 408966;
      "Google - auto-set privacy/GDPR consent cookie (prevent consent popup)" =
        424411;
      "Play Youtube playlist in reverse order" = 404986;
      "YouTube CPU Tamer" = 418283;
      "YouTube ScrollBar Remove" = 423150;
      "Youtube - dismiss sign-in" = 412178;
    };
  }
]
