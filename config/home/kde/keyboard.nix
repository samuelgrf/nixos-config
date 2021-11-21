{ nixosConfig, ... }:

with nixosConfig.services.xserver; {

  # Apply X keyboard config to Plasma Wayland.
  kxkbrc.Layout = {
    LayoutList = layout;
    VariantList = xkbVariant;
    Model = xkbModel;
    Options = xkbOptions;
    ResetOldOptions = true;
  };
}
