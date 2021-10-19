{ userData, ... }:

with userData; {

  # Define user accounts. Don't forget to set a password with ‘passwd’.
  users.users = {
    ${name} = {
      description = fullName;
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = authorizedSshKeysUser;
    };
    root = { openssh.authorizedKeys.keys = authorizedSshKeysRoot; };
  };

  # Set locale.
  i18n.defaultLocale = locale;

  # Set time zone.
  time = { inherit timeZone; };

  # Set keyboard layout.
  services.xserver = keyboard;

}
