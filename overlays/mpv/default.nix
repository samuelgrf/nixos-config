final: prev:
with prev; {

  mpv = mpv.override {
    scripts = with final.mpvScripts; [ sponsorblock youtube-quality ];
  };

}
