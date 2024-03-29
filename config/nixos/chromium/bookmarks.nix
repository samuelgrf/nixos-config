{ config, lib, ... }: {

  programs.chromium.extraOpts.ManagedBookmarks = [
    {
      name = "Manuals";
      children = [
        {
          name = "Nix Manual";
          url = "file:///run/current-system/sw/share/doc/nix/manual/index.html";
        }
        {
          name = "NixOS Manual";
          url = "file:///run/current-system/sw/share/doc/nixos/index.html";
        }
        {
          name = "Nixpkgs Manual";
          url = "file:///run/current-system/sw/share/doc/nixpkgs/manual.html";
        }
        {
          name = "Home Manager Manual";
          url =
            "file:///run/current-system/sw/share/doc/home-manager/index.html";
        }
      ];
    }
    (let inherit (config.system.nixos) release;
    in {
      name = "Nix & NixOS";
      children = [
        {
          name = "NixOS/nixpkgs: Nix Packages collection";
          url = "https://github.com/NixOS/nixpkgs";
        }
        {
          name = "Nixpkgs PR progress tracker";
          url = "https://nixpk.gs/pr-tracker.html";
        }
        {
          name = "NixOS Infra Status";
          url = "https://status.nixos.org/";
        }
        {
          name = "Hydra - Overview";
          url = "https://hydra.nixos.org/";
        }
        {
          name = "Hydra - Jobset nixos:release-${release}";
          url = "https://hydra.nixos.org/jobset/nixos/release-${release}";
        }
        {
          name = "Hydra - Jobset nixos:trunk-combined";
          url = "https://hydra.nixos.org/jobset/nixos/trunk-combined";
        }
        {
          name = "Useful Nix Hacks";
          url = "http://chriswarbo.net/projects/nixos/useful_hacks.html";
        }
      ];
    })
    {
      name = "Chrome";
      children = [
        {
          name = "Chrome Release Schedule";
          url = "https://www.chromestatus.com/features/schedule";
        }
        {
          name = "Chrome Enterprise release notes";
          url = "https://support.google.com/chrome/a/answer/7679408";
        }
        {
          name = "Chrome Enterprise policy list";
          url = "https://chromeenterprise.google/policies/";
        }
      ];
    }
  ] ++ import ./extensions+userscripts.nix { inherit lib; };

  programs.chromium.enable = true;
}
