{ stdenv, g810-led, fetchurl
, profile ? "/etc/g810-led/profile"
}:

stdenv.mkDerivation {
  pname = "g810-led-udev-rules";
  version = "${g810-led.version}";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/MatMoul/g810-led/v${g810-led.version}/udev/g810-led.rules";
    sha256 = "1spdhvk23h3f8dgz3094n8sb2f0s1lxvwi3ajj38y65c4vnm3fx2";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/etc/udev/rules.d
    cp $src 10-g810-led.rules
    substituteInPlace 10-g810-led.rules \
      --replace "/usr" "${g810-led}" \
      --replace "/etc/g810-led/profile" "${profile}"
    cp 10-g810-led.rules $out/etc/udev/rules.d
  '';
}
