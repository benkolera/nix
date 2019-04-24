self: super:
{
  all-cabal-hashes = builtins.fetchurl {
    url    = "https://github.com/commercialhaskell/all-cabal-hashes/archive/5072503e7084eea37fde87f2395565ca2f35aba7.tar.gz";
    sha256 = "0b4nlb9fmvdfpjlhsp9d14yvvc5dm8gic56gcd899m96pcdczgr1";
  };
  haskellPackages = with self.haskell.lib; super.haskellPackages.extend (hself: hsuper: {
    # The 0.2.0.2 version is broken in nixpkgs 2019-04-25.
    broadcast-chan = hself.callHackage "broadcast-chan" "0.2.0.2" {};
    # The version of taffybar in nixpkgs is pretty old. Bump it up.
    taffybar = hself.callCabal2nix "taffybar" (self.fetchFromGitHub {
      owner = "taffybar";
      repo = "taffybar";
      rev = "d4f983fe3f6ab1278aed1cc884b5afbcf1f4415d";
      sha256 = "1ay63pp5s8jlgnfm4l7lhj1qk862dwz9gh0n4dk4w0yygha8phw7";
    }) { inherit (self) gtk3;  };
  });
}
