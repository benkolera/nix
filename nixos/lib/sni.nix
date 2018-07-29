{ stdenv, ghcWithPackages, makeWrapper }:
let
  sniEnv = ghcWithPackages (self: [ self.status-notifier-item ]);
in stdenv.mkDerivation {
  name = "status-notifier-item";

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    mkdir -p $out/bin
    makeWrapper ${sniEnv}/bin/status-notifier-watcher $out/bin/status-notifier-watcher
    makeWrapper ${sniEnv}/bin/sni-cl-tool $out/bin/sni-cl-tool
  '';

  meta = {
    platforms = stdenv.lib.platforms.unix;
  };
}
