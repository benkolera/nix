self: super:
let
  gitinfo = self.lib.importJSON ./git.json;
  kaktree-src = self.fetchgit {
    inherit (gitinfo) url rev sha256;
  };
in {
  kaktree = kaktree-src;
}
