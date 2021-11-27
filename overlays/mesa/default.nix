_: prev:
with prev; {

  mesa_ANGLE = mesa.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (fetchpatch {
        url =
          "https://gitlab.freedesktop.org/mesa/mesa/uploads/37d674e71deef34cd6f2875efc4af70c/ANGLE_sync_control_rate.diff";
        sha256 = "DgO1oSofRw+C9pGAKwuNpu4V6IWHC6qTdzc1cZO4IZ0=";
      })
    ];
  });

}
