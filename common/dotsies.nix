{ lib, stdenv, fetchurl, unzip, p7zip }:

stdenv.mkDerivation rec {
  pname = "dotsies-fonts";
  version = "1";
  dotsies = fetchurl {
    url = "http://dotsies.org/Dotsies.ttf";
  };
  dotsies-training = fetchurl {
    url = "http://dotsies.org/Dotsies%20Training%20Wheels.ttf";
  };
  dotsies-wide = fetchurl {
    url = "http://dotsies.org/Dotsies%20Wide.ttf";
  };
  dotsies-context = fetchurl {
    url = "http://dotsies.org/Dotsies%20Context.ttf";
  };
  dotsies-stripped = fetchurl {
    url = "http://dotsies.org/Dotsies%20Striped.ttf";
  };
  dotsies-roman = fetchurl {
    url = "http://dotsies.org/Dotsies%20Roman.ttf";
  };
  dotsies-conf = fetchurl {
    url = "21-dotsies.conf";
  };

  pro = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
    sha256 = "sha256-g/SzgU3vOzm8uRuA6AN/N8Tnrl2Vpya58hx99dGfecI=";
  };

  compact = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Compact.dmg";
    sha256 = "sha256-SIht9sqmeijEeU4uLwm+tlZtFlTnD/G5GH8haUL6dlU=";
  };

  mono = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg";
    sha256 = "sha256-jnhTTmSy5J8MJotbsI8g5hxotgjvyDbccymjABwajYw=";
  };

  ny = fetchurl {
    url = "https://devimages-cdn.apple.com/design/resources/download/NY.dmg";
    sha256 = "sha256-Rr0UpJa7kemczCqNn6b8HNtW6PiWO/Ez1LUh/WNk8S8=";
  };

  nativeBuildInputs = [ p7zip ];

  sourceRoot = ".";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/usr/share/fonts/TTF

    mv ${dotsies} $out/usr/share/fonts/TTF
    mv ${dotsies} $out/usr/share/fonts/TTF
  '';

  meta = {
    description = "Apple San Francisco, New York fonts";
    homepage = "https://developer.apple.com/fonts/";
    license = lib.licenses.unfree;
  };
}
