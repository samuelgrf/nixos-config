{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      # Alias for unstable channel
      unstable = import <nixos-unstable> {
        config = config.nixpkgs.config;
        overlays = config.nixpkgs.overlays;
        localSystem = config.nixpkgs.localSystem;
        crossSystem = config.nixpkgs.crossSystem;
      };

      # Experimental Qt 5.14.2 channel, needed for newer versions of RPCS3
      # can be downloaded as tarball from:
      # https://github.com/petabyteboy/nixpkgs/archive/feature/qt-5-14-2.tar.gz
      qt-5-14-2 = import <qt-5-14-2> {
        config = config.nixpkgs.config;
        overlays = config.nixpkgs.overlays;
        localSystem = config.nixpkgs.localSystem;
        crossSystem = config.nixpkgs.crossSystem;
      };

      ### APPLICATIONS

      emacs-nox = pkgs.emacs.override {
        withX = false;
        withGTK2 = false;
        withGTK3 = false;
      };

      pcsx2_nativeOptimizations = super.pkgs.pkgsi686Linux.pcsx2.override {
        stdenv = super.pkgs.pkgsi686Linux.impureUseNativeOptimizations super.pkgs.pkgsi686Linux.stdenv;
      };

      # Update to newest version, needs Qt version >5.14 to work
      rpcs3_update =
        let
          majorVersion = "0.0.10-dev";
          gitVersion = "10427-865180e63"; # echo $(git rev-list HEAD --count)-$(git rev-parse --short HEAD)
          pkgs = self.qt-5-14-2;
        in
        pkgs.rpcs3.overrideAttrs (oldAttrs: {
          version = "${majorVersion}-${gitVersion}";

          src = pkgs.fetchgit {
            url = "https://github.com/RPCS3/rpcs3";
            rev = "865180e63e10b5336ca062829d6b1fad8618a3c7";
            sha256 = "0l1f7hmwxfsayjwj9l9q90vsclg9sihg99ykxw78vqc81xkmznzz";
          };

          preConfigure = ''
            cat > ./rpcs3/git-version.h <<EOF
            #define RPCS3_GIT_VERSION "${gitVersion}"
            #define RPCS3_GIT_BRANCH "HEAD"
            #define RPCS3_GIT_FULL_BRANCH "RPCS3/rpcs3/master"
            #define RPCS3_GIT_VERSION_NO_UPDATE 1
            EOF
          '';
      });

      rpcs3_update_nativeOptimizations =
        let
          pkgs = self.qt-5-14-2;
        in
        (self.rpcs3_update.override {
          mkDerivation = (pkgs.impureUseNativeOptimizations pkgs.stdenv).mkDerivation;
        })
          .overrideAttrs (oldAttrs: {
            # Enable native optimizations in CMake
            cmakeFlags = [
              "-DUSE_SYSTEM_LIBPNG=ON"
              "-DUSE_SYSTEM_FFMPEG=ON"
              "-DUSE_NATIVE_INSTRUCTIONS=ON"
            ];

            # Add QT wrapper, this is needed because we are using stdenv.mkDerivation
            # instead of mkDerivation
            nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ pkgs.qt5.wrapQtAppsHook ];

            # Add vulkan-headers needed for Vulkan support
            buildInputs = (oldAttrs.buildInputs or []) ++ [ pkgs.vulkan-headers ];
        });

      ### TOOLS

      g810-led = super.callPackage ./g810-led { };

      gamemode32 = super.callPackage_i686 ./gamemode32 { };
      gamemode = super.callPackage ./gamemode { };

      inih = super.callPackage ./inih { }; # GameMode dependency

      lux = super.callPackage ./lux { };

      w7zip = super.callPackage ./w7zip { };

      ### MISC

      amdvlk = super.callPackage ./amdvlk { };

      linuxPackages = super.linuxPackages.extend (self: super: {
        rtl8821ce = super.callPackage ./rtl8821ce { };
      });

      # Copied from https://github.com/cleverca22/nixos-configs/blob/master/overlays/qemu/default.nix
      qemu-user-arm = if self.stdenv.system == "x86_64-linux"
        then self.pkgsi686Linux.callPackage ./qemu-user { user_arch = "arm"; }
        else self.callPackage ./qemu-user { user_arch = "arm"; };
      qemu-user-x86 = self.callPackage ./qemu-user { user_arch = "x86_64"; };
      qemu-user-arm64 = self.callPackage ./qemu-user { user_arch = "aarch64"; };
      qemu-user-riscv32 = self.callPackage ./qemu-user { user_arch = "riscv32"; };
      qemu-user-riscv64 = self.callPackage ./qemu-user { user_arch = "riscv64"; };
    })
  ];
}
