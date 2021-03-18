{ fetchFromGitHub, kernel, lib, stdenv }:

let
  modDestDir =
    "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw88";
in stdenv.mkDerivation {
  pname = "rtw88";
  version = "unstable-2021-03-09";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw88";
    rev = "ac0f6cb850962937b21a47ede9b7377113fe6186";
    hash = "sha256-mVh47rnoC526D3VkZmDgi39ZPU0n5PZKznzk7HxyoDQ=";
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
