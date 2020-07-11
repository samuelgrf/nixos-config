{ config, ... }:

{
  nixpkgs.overlays = [
    (self: super: {

      ##########################################################################
      ## Channel aliases
      ##########################################################################

      # Alias for unstable channel
      unstable = import <nixos-unstable> {
        config = config.nixpkgs.config;
        overlays = config.nixpkgs.overlays;
        localSystem = config.nixpkgs.localSystem;
        crossSystem = config.nixpkgs.crossSystem;
      };


      ##########################################################################
      ## Packages
      ##########################################################################

      # The Vulkan Loader tries to load the default driver from $share/vulkan/icd.d/
      # Prevent loading AMDVLK by default by moving the driver to $share/amdvlk/icd.d/
      amdvlk_noDefault = super.symlinkJoin {
        name = "amdvlk_noDefault";
        paths = [ "${self.amdvlk}/share/vulkan" ];
        postBuild = ''
          mkdir -p $out/share/amdvlk
          mv $out/icd.d $out/share/amdvlk
        '';
      };

      g810-led = super.callPackage ./g810-led { };

      # Remove Windows font variants from Nerd Fonts
      nerdfonts_no-winfonts = super.nerdfonts.overrideAttrs (oldAttrs: {
        preFixup = ''
          rm -rfv $out/share/fonts/truetype/NerdFonts/*Windows\ Compatible.ttf
        '';
      });

      hack_nerdfont = self.nerdfonts_no-winfonts.override { fonts = [ "Hack" ]; };
      meslo-lg_nerdfont = self.nerdfonts_no-winfonts.override { fonts = [ "Meslo" ]; };

      mpv_sponsorblock = super.mpv.override {
        scripts = [
          (super.callPackage ./mpv-scripts/sponsorblock.nix { })
        ];
      };

      # Remove Oh My Zsh functions that don't work on Nix
      oh-my-zsh = super.oh-my-zsh.overrideAttrs (oldAttrs: {
        phases = [ oldAttrs.phases "preInstall" ];
        preInstall = ''
          chmod -R +w lib
          sed -i -e "/uninstall_oh_my_zsh()/,+3 d" \
                 -e "/upgrade_oh_my_zsh()/,+3 d" \
              lib/functions.zsh
        '';
      });

    })
  ];
}
