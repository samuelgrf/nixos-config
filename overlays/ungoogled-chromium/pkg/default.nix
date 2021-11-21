_: prev:
with prev; {

  ungoogled-chromium = let
    argsOverride = ungoogled-chromium.passthru.argsOverride or { } // {
      ungoogled = true;
      channel = "ungoogled-chromium";
    };

  in callPackage ./_default.nix argsOverride // {
    passthru = { inherit argsOverride; };
  };
}
