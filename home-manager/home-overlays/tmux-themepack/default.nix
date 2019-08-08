self: super:
let
  gitinfo = self.lib.importJSON ./git.json;
  themepack-src = self.fetchgit {
    inherit (gitinfo) url rev sha256;
  };
in {
  tmux-themepack = themepack-src;
}
