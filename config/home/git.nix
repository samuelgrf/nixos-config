{ userData, ... }:

with userData; {

  # Configure Git.
  programs.git = {
    enable = true;
    userName = fullName;
    userEmail = email;
    signing.key = gpgKey;
    signing.signByDefault = true;

    delta = {
      enable = true;
      options.line-numbers = true;
    };

    extraConfig = {
      pull.ff = "only";
      url."ssh://git@github.com/".pushInsteadOf = "https://github.com/";
      url."ssh://git@gitlab.com/".pushInsteadOf = "https://gitlab.com/";
    };
  };
}
