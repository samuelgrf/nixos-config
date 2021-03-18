{ lib, linuxPackages_zen, stdenv }:

stdenv.mkDerivation {
  pname = "rtw88-firmware";
  inherit (linuxPackages_zen.rtw88) version src;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/rtw88
    cp *.bin $out/lib/firmware/rtw88

    runHook postInstall
  '';

  meta = with lib; {
    description = "Firmware for the newest Realtek rtlwifi codes";
    homepage = "https://github.com/lwfinger/rtw88";
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ samuelgrf tvorog ];
  };
}
