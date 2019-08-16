self: super:
let
  gitinfo = self.lib.importJSON ./git.json;
  kak-powerline-src = self.fetchgit {
    inherit (gitinfo) url rev sha256;
  };
in {
  kak-powerline = kak-powerline-src;
}
