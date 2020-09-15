{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "cod";
  version = "unstable-2020-09-10";

  goPackagePath = pname;
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "dim-an";
    repo = pname;
    rev = "ae68da08339471dd278d6df79abbfd6fe89a10fe";
    sha256 = "1l3gn9v8dcy72f5xq9hwbkvkis0vp4dp8qyinsrii3acmhksg9v6";
  };

  buildFlagsArray = [ "-ldflags=-X main.GitSha=${src.rev}" ];

  meta = with lib; {
    description = "Tool for generating Bash/Zsh autocompletions based on `--help` output";
    homepage = src.meta.homepage;
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
