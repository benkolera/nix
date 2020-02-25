self: super:
let 
  stylish-haskell-json = builtins.fromJSON (builtins.readFile ./git.json);
  stylish-haskell-src  = builtins.fetchGit { inherit (stylish-haskell-json) url rev; };
  haskellPackages = super.haskellPackages.override {
    overrides = hpNew: hpOld: rec {
      #foo = hpNew.callPackage /path/to/default.nix { };

      # HsYAML-aeson & stylish-haskell overrides are
      # tied together and are from https://github.com/NixOS/nixpkgs/pull/79528/files

      HsYAML-aeson = hpOld.HsYAML-aeson.override {
        HsYAML = hpNew.HsYAML_0_2_1_0;
      };

      stylish-haskell = hpNew.callCabal2nix "stylish-haskell" stylish-haskell-src {
        HsYAML = hpNew.HsYAML_0_2_1_0;
      };
    };
  };
in {
  stylish-haskell = haskellPackages.stylish-haskell;
}
