self: super:
let
  gitinfo = self.lib.importJSON ./git.json;
  kakoune-src = self.fetchgit {
    inherit (gitinfo) url rev sha256;
  };
  kakoune-unwrapped = super.stdenv.mkDerivation rec {
    pname = "kakoune-unwrapped";
    version = "2020.01.16";
    src = kakoune-src; 
    nativeBuildInputs = [ self.pkgconfig ];
    buildInputs = with self; [ ncurses asciidoc docbook_xsl libxslt ];
    makeFlags = [ "debug=no" ];

    postPatch = ''
      export PREFIX=$out
      cd src
      sed -ie 's#--no-xmllint#--no-xmllint --xsltproc-opts="--nonet"#g' Makefile
    '';

    preConfigure = ''
      export version="v${version}"
    '';

    doInstallCheckPhase = true;
    installCheckPhase = ''
      $out/bin/kak -ui json -E "kill 0"
    '';
  };
in {
  kakoune = super.wrapKakoune kakoune-unwrapped;
}
