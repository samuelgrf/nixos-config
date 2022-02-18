{
  fullName = "Samuel Gräfenstein";
  name = "samuel";
  email = "s@muel.gr";
  gpgKey = "6F2E2A90423C8111BFF2895EDE75F92E318123F0";

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
