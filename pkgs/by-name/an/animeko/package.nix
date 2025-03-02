{
  stdenv,
  fetchFromGitHub,
  lib,
  gradle_8,
  jetbrains,
  vlc,
  libGL,
}:

let
  self = stdenv.mkDerivation (finalAttrs: {
    pname = "animeko";
    version = "4.5.0";

    src = fetchFromGitHub {
      owner = "open-ani";
      repo = "animeko";
      rev = "v${finalAttrs.version}";
      hash = "sha256-uWt3x8u8sU0amYsUX4FMIWp83FS9NWP/7npogKzpEi0=";
    };

    nativeBuildInputs = [ gradle_8 ];

    mitmCache = gradle_8.fetchDeps {
      pkg = self;
      data = ./deps.json;
    };

    preBuild = ''
      echo "jvm.toolchain.version=21" >> local.properties
    '';

    gradleFlags = [ "-Dorg.gradle.java.home=${jetbrains.jdk}" ];

    gradleBuildTask = "createReleaseDistributable";

    doCheck = false;

    installPhase = ''
      mkdir -p $out/{bin,lib}
      cp app/desktop/build/compose/binaries/main-release/app/Ani/bin/Ani $out/bin/
      cp -r app/desktop/build/compose/binaries/main-release/app/Ani/lib/* $out/lib/
    '';

    meta = with lib; {
      description = "Animation platform with bangumi, bitorrent and danmaku support";
      homepage = "https://github.com/open-ani/animeko";
      license = licenses.agpl3Only;
      maintainers = with maintainers; [ pokon548 ];
      platforms = platforms.linux;
    };
  });
in
self
