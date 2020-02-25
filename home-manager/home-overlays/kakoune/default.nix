self: super:
let
  gitinfo = self.lib.importJSON ./git.json;
  kakoune-src = self.fetchgit {
    inherit (gitinfo) url rev sha256;
  };
in {
  kakoune = kakoune-src;
}
