{ pkgs, ... }: {

  home.file.".local/share/lutris/runtime/dxvk/async".source = pkgs.dxvk-async;
}
