_: prev: {

  mpvScripts = prev.mpvScripts // {

    sponsorblock = prev.mpvScripts.sponsorblock.overrideAttrs (oldAttrs: {
      postPatch = (oldAttrs.postPatch or "") + ''
        substituteInPlace sponsorblock.lua \
          --replace 'skip_categories = "sponsor"' \
            'skip_categories = "sponsor,intro,interaction,selfpromo"' \
          --replace 'local_pattern = ""' \
            'local_pattern = "-([%w-_]+)%.[mw][kpe][v4b]m?$"'
      '';
    });
  };

}
