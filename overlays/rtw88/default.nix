{ fetchFromGitHub, kernel, lib, stdenv }:

stdenv.mkDerivation {
  pname = "rtw88";
  version = "unstable-2020-03-09";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw88";
    rev = "ac0f6cb850962937b21a47ede9b7377113fe6186";
    hash = "sha256-mVh47rnoC526D3VkZmDgi39ZPU0n5PZKznzk7HxyoDQ=";
  };

  makeFlags = [
    "KVER=${kernel.modDirVersion}"
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "FIRMWAREDIR=\${out}/lib/firmware"
    "MODDESTDIR=\${out}/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw88"
  ];

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw88"
    substituteInPlace ./Makefile \
      --replace depmod \#
  '';

  meta = with lib; {
    description = "The newest Realtek rtlwifi codes";
    homepage = "https://github.com/lwfinger/rtw88";
    # Firmware blobs are installed to "$out/lib/firmware/rtw88".
    license = licenses.unfreeRedistributableFirmware;
    platforms = platforms.linux;
    maintainers = with maintainers; [ samuelgrf ];
  };
}
