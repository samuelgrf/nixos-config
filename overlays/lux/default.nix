{ stdenv, fetchgit, coreutils }:

stdenv.mkDerivation rec {
  pname = "lux";
  version = "1.21";

  src = fetchgit {
    url = "https://github.com/Ventto/lux.git";
    rev = "v${version}";
    sha256 = "1y47s9z6mhg919f7wjsq0j6zni0x32aviimp6qa914ir2vlcv0cq";
  };

  buildInputs = [ coreutils ];

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  patchPhase = ''
    substituteInPlace 99-lux.rules --replace /bin ${coreutils}/bin
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp lux.sh $out/bin/lux
    install -D 99-lux.rules $out/etc/udev/rules.d/99-lux.rules
  '';

  meta = with stdenv.lib; {
    description = "POSIX-compliant Shell script to control brightness";
    homepage = "https://github.com/Ventto/lux";
    # maintainers = with maintainers; [ samuelgrf ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
