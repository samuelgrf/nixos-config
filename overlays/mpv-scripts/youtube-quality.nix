{ stdenv, fetchgit }:

# Usage: `pkgs.mpv.override { scripts = [ pkgs.mpvScripts.sponsorblock ]; }`
stdenv.mkDerivation {
  pname = "mpv-youtube-quality";
  version = "unstable-2020-02-11";

  src = fetchgit {
    url = "https://github.com/jgreco/mpv-youtube-quality.git";
    rev = "1f8c31457459ffc28cd1c3f3c2235a53efad7148";
    sha256 = "09z6dkypg0ajvlx02270p3zmax58c0pkqkh6kh8gy2mhs3r4z0xy";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/mpv/scripts
    cp -r youtube-quality.lua $out/share/mpv/scripts/
  '';

  passthru.scriptName = "youtube-quality.lua";

  meta = with stdenv.lib; {
    description = "mpv script for changing YouTube video quality (ytdl-format) on the fly.";
    homepage = "https://github.com/jgreco/mpv-youtube-quality";
    platforms = platforms.all;
    # maintainers = with maintainers; [ samuelgrf ];
  };
}
