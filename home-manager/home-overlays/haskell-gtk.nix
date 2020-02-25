self: super: {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: {})) (hself: hsuper: {
      gi-gdkx11 = hself.callCabal "gi-gdkx11" "3.0.9" {};
    });
  });
}
