_: prev:
with prev; {

  nix-zsh-completions = nix-zsh-completions.overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "Ma27";
      repo = "nix-zsh-completions";
      rev = "939c48c182e9d018eaea902b1ee9d00a415dba86";
      hash = "sha256-3HVYez/wt7EP8+TlhTppm968Wl8x5dXuGU0P+8xNDpo=";
    };
  });

}