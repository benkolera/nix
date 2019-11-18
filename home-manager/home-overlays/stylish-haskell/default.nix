self: super:
let 
  taffybar-json = builtins.fromJSON (builtins.readFile ./git.json);
  taffybar-src  = builtins.fetchGit { inherit (taffybar-json) url rev; };
in {
  stylish-haskell = self.haskellPackages.callCabal2nix taffybar-src "stylish-haskell" {};
}
