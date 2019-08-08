self: super:
# See https://github.com/NixOS/nixpkgs/issues/63500
# Taffybar's default.nix has a nixpkgs pin and overlays that it maintains
# lets ignore messing with our haskell pkgs and just use it as the toplevel.
# This is pretty gross and will likely break later, ofc
let 
  taffybar-json = builtins.fromJSON (builtins.readFile ./git.json);
  taffybar-src  = builtins.fetchGit { inherit (taffybar-json) url rev; };
  taffybar-overlay = _: pkgs: {
    haskellPackages = pkgs.haskellPackages.override (old: {
      overrides = pkgs.lib.composeExtensions (old.overrides or (_: _: {})) (self: super: {
        taffybar = self.callCabal2nix "taffybar" taffybar-src { inherit (pkgs) gtk3; };
      });
    });
  };
in taffybar-overlay self super
