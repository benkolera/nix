{ nixpkgs ? import <nixpkgs> {} }:
let gitinfo = nixpkgs.pkgs.lib.importJSON ./git.json;
in import (nixpkgs.pkgs.fetchgit {
  inherit (gitinfo) url rev sha256;
}) {}
