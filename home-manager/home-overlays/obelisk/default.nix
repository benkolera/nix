self: super:
let gitinfo = self.lib.importJSON ./git.json;
in {
  obelisk = import (self.fetchgit {
    inherit (gitinfo) url rev sha256;
  }) {};
}
