_: prev:

with prev.lib // import ../../lib { inherit (prev) lib; };

mapAttrsRecursiveCond (x: !isDerivation x)
(_: x: if isAttrs x then x // { exe = mainProgram x; } else x) prev
