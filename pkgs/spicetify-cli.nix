{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.40.10";
in
buildGoModule {
  pname = "spicetify-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-S9vC7gAbwW8YSpXyDryalXHW3aWffGlelyc/oaE5vXg=";
  };

  vendorHash = "sha256-901njlGcAxr12F9w6yQ+ESsptlwsZsMvKPUmlHxehmA=";

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
