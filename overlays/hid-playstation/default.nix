{ lib, stdenv, fetchgit, kernel }:

stdenv.mkDerivation rec {
  pname = "hid-playstation-${kernel.version}";
  version = "unstable-2021-02-07";

  src = fetchgit {
    url = "https://aur.archlinux.org/hid-playstation-dkms.git";
    rev = "afac0ba15393af6db9572e329127ce73eb143888";
    sha256 = "sha256-7Q/wBGzekgHiFlLMUfcFKhG6VZV5q7VGwjBvInlXwi8=";
  };

  patches = [ "${src}/disable-ff-enabled-check.patch" ];

  makeFlags = [
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "DESTDIR=\${out}/lib/modules/${kernel.modDirVersion}/kernel/drivers/hid"
  ];

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/hid"
  '';

  meta = with lib; {
    description = "Sony's official HID driver for the PS5 DualSense controller";
    homepage = "https://patchwork.kernel.org/project/linux-input/list/?series=429573";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ samuelgrf ];
  };
}
