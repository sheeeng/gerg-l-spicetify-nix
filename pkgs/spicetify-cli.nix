{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.40.5";
in
buildGoModule {
  pname = "spicetify-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-qBUGi4Q1RZnJ7cXNT9fjSPj5CVdku37h5+4Pv42/B7Q=";
  };

  vendorHash = "sha256-yCxEpfqZRJcx4KevS+vqq6taHCZyEw1VK4Xt6BPPFAo=";

  ldflags = [
    "-s -w"
    "-X 'main.version=Dev'"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/spicetify
    ln -s $src/jsHelper $out/bin/jsHelper
    ln -s $src/css-map.json $out/bin/css-map.json
  '';

  meta = {
    description = "Command-line tool to customize Spotify client";
    homepage = "https://github.com/spicetify/cli";
    license = lib.licenses.gpl3Plus;
    mainProgram = "spicetify";
  };
}
