_: prev:
with prev; {

  gimpPlugins = gimpPlugins // {

    bimp = stdenv.mkDerivation rec {
      /* menu:
         File/Batch Image Manipulation...
      */
      pname = "bimp";
      version = "2.5";

      src = fetchFromGitHub {
        owner = "alessandrofrancesconi";
        repo = "gimp-plugin-bimp";
        rev = "v${version}";
        hash = "sha256-s2FtSLzjfi0KbfE+6m1T6GaqXo5ZJJasQimouTp/EkA=";
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
