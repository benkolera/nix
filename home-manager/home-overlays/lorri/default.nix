self: super:
let
  gitinfo = self.lib.importJSON ./git.json;
  lorri-src = self.fetchgit {
    inherit (gitinfo) url rev sha256;
  };
in {
  lorri = import lorri-src { src = lorri-src; };
}
