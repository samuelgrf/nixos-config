_: prev:
with prev; {

  gimpPlugins = gimpPlugins // {
    bimp = stdenv.mkDerivation rec {
      /* menu:
         File/Batch Image Manipulation...
      */
      pname = "bimp";
      version = "2.6";

      src = fetchFromGitHub {
        owner = "alessandrofrancesconi";
        repo = "gimp-plugin-bimp";
        rev = "v${version}";
        hash = "sha256-IJ3+/9UwxJTRo0hUdzlOndOHwso1wGv7Q4UuhbsFkco=";
      };

      buildInputs = [ gimp gimp.gtk glib ];

      nativeBuildInputs = [ pkg-config which ];

      installPhase = ''
        runHook preInstall

        install -Dt $out/${gimp.targetPluginDir}/bimp bin/bimp

        runHook postInstall
      '';

      meta = with lib; {
        description = "Batch Image Manipulation Plugin for GIMP";
        homepage = "https://github.com/alessandrofrancesconi/gimp-plugin-bimp";
        license = licenses.gpl2Plus;
      };
    };
  };
}
