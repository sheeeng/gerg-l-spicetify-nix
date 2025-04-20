{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.39.7";
in
buildGoModule {
  pname = "spicetify-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "spicetify";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-iqx+bwq99xNUt2NEc3ZFxPdfE+WJPhmJXJ26sPCm8sk=";
  };

  vendorHash = "sha256-wSmKzof3nAyA+wI8kXQu/t5Fz4l22JyW50PCuOrWK1k=";

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
