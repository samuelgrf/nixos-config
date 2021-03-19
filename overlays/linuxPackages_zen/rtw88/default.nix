{ fetchFromGitHub, kernel, lib, stdenv }:

let
  modDestDir =
    "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw88";
in stdenv.mkDerivation {
  pname = "rtw88";
  version = "unstable-2021-03-19";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw88";
    rev = "ca416103d04fcb4a7ed01f09779f17601faf58c0";
    hash = "sha256-R9MquLfKqSnESWdMfXXnHhpjrUZXo8+njkiy+xaAz9Q=";
  };

  makeFlags =
    [ "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents {} ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f {} \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "The newest Realtek rtlwifi codes";
    homepage = "https://github.com/lwfinger/rtw88";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ samuelgrf tvorog ];
    priority = -1;
  };
}
