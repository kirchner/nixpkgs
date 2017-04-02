{ stdenv, lib, fetchFromGitHub, rustPlatform, pkgconfig
, xorg, cmake, freetype, fontconfig, xclip }:

with rustPlatform;

buildRustPackage rec {
  name = "alacritty-${version}";
  version = "2017-03-27";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "8d4c10dad65a2a26c5801448ed82ed8ebef6850a";
    sha256 = "0yp4iyzbjappiwsn2hhw0yypzs6q9in9pxlzihk7j6n3mmmrblp9";
  };

  #sourceRoot = "habitat-${version}-src/components/hab";

  depsSha256 = "1vag8dxz67qvrp5x5xccy88aibxy2ih1bz14bmjgi9zwrv17gz6v";

  buildInputs = [
    cmake
    freetype
    fontconfig
    xclip
  ];

  nativeBuildInputs = [ pkgconfig ];

  propagatedBuildInputs = [
    xorg.libX11
    xorg.libXcursor
    xorg.libXxf86vm
    xorg.libXi
  ];

  meta = with lib; {
    description = "An application automation framework";
    homepage = https://www.habitat.sh;
    license = licenses.asl20;
    #maintainers = [ maintainers.rushmorem ];
    #platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
