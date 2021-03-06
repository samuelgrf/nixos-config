{ fetchFromGitHub, lib, mpv-unwrapped, stdenv }:

# Usage: `pkgs.mpv.override { scripts = [ pkgs.mpvScripts.youtube-quality ]; }`
stdenv.mkDerivation rec {
  pname = "mpv-youtube-quality";
  version = "unstable-2020-02-11";

  src = fetchFromGitHub {
    owner = "jgreco";
    repo = pname;
    rev = "1f8c31457459ffc28cd1c3f3c2235a53efad7148";
    hash = "sha256-voNP8tCwCv8QnAZOPC9gqHRV/7jgCAE63VKBd/1s5ic=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/mpv/scripts
    cp -r youtube-quality.lua $out/share/mpv/scripts/
  '';

  passthru.scriptName = "youtube-quality.lua";

  meta = with lib; {
    description =
      "mpv script for changing YouTube video quality (ytdl-format) on the fly";
    inherit (src.meta) homepage;
    inherit (mpv-unwrapped.meta) platforms;
    maintainers = with maintainers; [ samuelgrf ];
  };
}
