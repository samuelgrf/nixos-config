_final: prev: {

  hydra-check = prev.hydra-check.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./support-tested-job.patch ];
  });
}
