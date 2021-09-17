{

  # Configure Git.
  programs.git = {
    enable = true;
    userName = "Samuel Gräfenstein";
    userEmail = "git@samuelgrf.com";
    signing.key = "FF2458328FAF466018C6186EEF76A063F15C63C8";
    signing.signByDefault = true;

    delta = {
      enable = true;
      options.line-numbers = true;
    };

    extraConfig = {
      init.defaultBranch = "master";
      pull.ff = "only";
      url."ssh://git@github.com/".pushInsteadOf = "https://github.com/";
      url."ssh://git@gitlab.com/".pushInsteadOf = "https://gitlab.com/";
    };
  };

}
