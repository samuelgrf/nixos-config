{

  # Define user accounts. Don't forget to set a password with ‘passwd’.
  users.users.samuel = {
    description = "Samuel Gräfenstein";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # Set locale.
  i18n.defaultLocale = "en_IE.UTF-8";

  # Set time zone.
  time.timeZone = "Europe/Berlin";

  # Set keyboard layout.
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "caps:escape";
  };

}
