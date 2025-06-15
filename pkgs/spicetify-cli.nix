{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.40.11";
in
buildGoModule {
  pname = "spicetify-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-CVCp9XzbVM0XAtgtBfMLLQTymzMTZfpoL9RrLI9MaDY=";
  };

  vendorHash = "sha256-iD6sKhMnvc0RczoSCWCx/72/zjoC6YQyV+AYyE4w/b0=";

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
