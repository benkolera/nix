self: super: {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: {})) (hself: hsuper: {
      gi-gdkx11 = self.haskell.lib.overrideCabal (hself.callHackage "gi-gdkx11" "3.0.9" {}) (drv: {
        libraryPkgconfigDepends = [ self.gtk3-x11 ];
      });
    });
  });
}
