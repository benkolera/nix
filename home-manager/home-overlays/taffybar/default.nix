# This should be temporary: see https://github.com/NixOS/nixpkgs/issues/55692
self: super:
{
  haskellPackages = with self.haskell.lib; super.haskellPackages.extend (hself: hsuper: {
    #gi-gdk = hsuper.gi-gdk.override { inherit gtk3; };
    taffybar = hself.callCabal2nix "taffybar" (self.fetchFromGitHub {
      owner = "taffybar";
      repo = "taffybar";
      rev = "d4f983fe3f6ab1278aed1cc884b5afbcf1f4415d";
      sha256 = "0qncwpfz0v2b6nbdf7qgzl93kb30yxznkfk49awrz8ms3pq6vq6g";
    }) { inherit (self) gtk3;  };
  });
}
