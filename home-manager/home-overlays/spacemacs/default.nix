(self: super:
let gitinfo = self.lib.importJSON ./git.json;
in {
  spacemacs = self.fetchgit {
    inherit (gitinfo) url rev sha256;
  };
})
