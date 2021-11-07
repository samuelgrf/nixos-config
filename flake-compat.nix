let
  lock = __fromJSON (__readFile ./flake.lock);
  flake-compat = fetchTarball {
    url =
      "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
    sha256 = lock.nodes.flake-compat.locked.narHash;
  };

in (import flake-compat { src = ./.; }).defaultNix
