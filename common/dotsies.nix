{ lib, stdenv, fetchurl, unzip, p7zip }:

stdenv.mkDerivation rec {
  pname = "dotsies-fonts";
  version = "1";

  sourceRoot = ".";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype

    cp ${../res/font/Dotsies.ttf} $out/share/fonts/truetype
    cp ${../res/font/siesdot.ttf} $out/share/fonts/truetype
  '';

  meta = {
    description = "Dotsies fonts";
    homepage = "https://dotsies.org/";
    license = lib.licenses.unfree;
  };
}
