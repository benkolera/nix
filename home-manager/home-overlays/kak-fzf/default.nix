self: super:
let
  gitinfo = self.lib.importJSON ./git.json;
  kak-fzf-src = self.fetchgit {
    inherit (gitinfo) url rev sha256;
  };
in {
  kak-fzf = kak-fzf-src;
}
