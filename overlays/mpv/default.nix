final: prev: {

  mpv = prev.mpv.override {
    scripts = with final.mpvScripts; [ sponsorblock youtube-quality ];
  };

}
