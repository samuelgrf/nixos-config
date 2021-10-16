{

  fullName = "Samuel Gräfenstein";
  name = "samuel";
  email = "git@samuelgrf.com";
  gpgKey = "FF2458328FAF466018C6186EEF76A063F15C63C8";

  authorizedSshKeysUser = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwTxBMRYCd0AKW5vDWbOuyfevl+VH/ntDwrvFw5rbzt samuel@amethyst"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDnGnsUmj08UT8r8nDfStCgDpo0e2KrhTb+69e2QKZvA samuel@beryl"
  ];
  authorizedSshKeysRoot = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC68A6rSbE4UeZgTLJKiIVbTgZRgeeVy8P2BWWgVbWp6 root@amethyst"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJeWZ1+Yxu0qcL131/4M3o0++qNgFXANrTxSJe8JbzZa root@beryl"
  ];

  locale = "en_IE.UTF-8";
  timeZone = "Europe/Berlin";
  keyboard = {
    layout = "us,de";
    xkbVariant = "altgr-intl,nodeadkeys";
    xkbOptions = "caps:escape";
  };

}
