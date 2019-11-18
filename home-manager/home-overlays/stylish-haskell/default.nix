self: super:
let 
  stylish-haskell-json = builtins.fromJSON (builtins.readFile ./git.json);
  stylish-haskell-src  = builtins.fetchGit { inherit (stylish-haskell-json) url rev; };
in {
  stylish-haskell = self.haskellPackages.callCabal2nix "stylish-haskell" stylish-haskell-src {};
}
