{ stdenv, lib, fetchgit, hidapi }:

stdenv.mkDerivation {
  pname = "g810-led";
  version = "0.3.9";

  src = fetchgit {
    url = "https://github.com/MatMoul/g810-led.git";
    rev = "v0.3.9";
    sha256 = "16k5zqr5p1426a33wwfh97s6b45bkj5adb6xpnn88pqc854hnsx7";
  };

  buildInputs = [ hidapi ];

  installPhase = ''
    install -D bin/g810-led $out/bin/g810-led
    ln -s $out/bin/g810-led $out/bin/g213-led
    ln -s $out/bin/g810-led $out/bin/g410-led
    ln -s $out/bin/g810-led $out/bin/g413-led
    ln -s $out/bin/g810-led $out/bin/g512-led
    ln -s $out/bin/g810-led $out/bin/g513-led
    ln -s $out/bin/g810-led $out/bin/g610-led
    ln -s $out/bin/g810-led $out/bin/g910-led
    ln -s $out/bin/g810-led $out/bin/gpro-led
  '';

  meta = with stdenv.lib; {
    description = "Linux led controller for Logitech G213, G410, G413, G512, G513, G610, G810, G910 and GPRO Keyboards";
    homepage = "https://github.com/MatMoul/g810-led";
    maintainers = with maintainers; [ samuelgrf ];
    license = licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
  };
}
