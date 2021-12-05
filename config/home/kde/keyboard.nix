{ nixosConfig, ... }:

with nixosConfig.services.xserver; {

  # Apply X keyboard config to Plasma Wayland.
  kxkbrc.Layout = {
    Use = true;
    LayoutList = layout;
    VariantList = xkbVariant;
    Model = xkbModel;
    Options = xkbOptions;
  };
}
