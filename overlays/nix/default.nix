_: prev:
with prev; {

  nixUnstable = nixUnstable.overrideAttrs (_: {
    version = "2.4pre20210601_aedb5c7";

    src = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "aedb5c7301d3ee45083d71137b228f4e79bf4868";
      hash = "sha256-kh61ACgX9H4bqQaC0j1SgOoBqvv5v5K+MFl7x1UeMIY=";
    };

    patches = [ ];
  });

}
