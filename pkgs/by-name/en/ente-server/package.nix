{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, libsodium
}:

buildGoModule rec {
  pname = "ente-server";
  version = "0.8.94";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    rev = "photos-v${version}"; # ente does not made releases for server. I will follow client version for now.
    hash = "sha256-oKBevT+fmXXaCSnh/6pLO+DCtB39xZFcU9QcFLElx4Y=";
  };

  vendorHash = "sha256-D3pJYrip2EEj98q3pawnSkRUiIyjLm82jlmV7owA69Q=";
  sourceRoot = "${src.name}/server";

  patches = [
    ./go.mod.patch
  ];

  buildInputs = [ libsodium ];
  nativeBuildInputs = [ pkg-config ];

  buildPhase = ''
    runHook preBuild

    go build -o $GOPATH/bin/${pname} cmd/museum/main.go

    runHook postBuild
  '';

  meta = with lib; {
    description = "Fully open source, End to End Encrypted alternative to Google Photos and Apple Photos";
    homepage = "https://ente.io";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ pokon548 ];
    mainProgram = "ente-server";
    platforms = platforms.all;
  };
}
