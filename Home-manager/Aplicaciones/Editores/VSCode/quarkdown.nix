{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  jdk17_headless,
  nodejs,
  chromium,
  withPdfSupport ? true,
}:

let
  pname = "quarkdown";
  version = "1.13.0";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchzip {
    url = "https://github.com/iamgio/quarkdown/releases/download/v${version}/quarkdown.zip";
    hash = "sha256-b+Mu8tMf8DrM+V/PUNeeUd2yOMx2q6H0SGiSLEYGMNg=";  # tu hash
    stripRoot = true;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mkdir -p $out/bin
    mkdir -p $out/docs

    cp -r lib/* $out/lib/
    cp -r docs/* $out/docs/

    makeWrapper ${jdk17_headless}/bin/java $out/bin/quarkdown \
      --add-flags "-classpath '$out/lib/*'" \
      --add-flags "com.quarkdown.cli.QuarkdownCliKt" \
      --set QD_NO_SANDBOX "true" \
      --set APP_HOME "$out" \
      ${lib.optionalString withPdfSupport "--prefix PATH : ${lib.makeBinPath [ nodejs ]}"} \
      ${lib.optionalString withPdfSupport "--set BROWSER_CHROMIUM ${chromium}/bin/chromium"}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Markdown with superpowers — from ideas to papers, presentations and books";
    homepage = "https://quarkdown.com";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    mainProgram = "quarkdown";
  };
}
