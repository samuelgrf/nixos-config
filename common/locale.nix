{ config, ... }:

{
  # Set locale
  i18n.defaultLocale = "en_IE.UTF-8";

  # Set time zone
  time.timeZone = "Europe/Berlin";

  # Set keyboard layout
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "caps:escape";
  };
}
