{ stdenv
, fetchFromGitHub
, qmake
, xpdf
, qtxmlpatterns
, qtsvg
, qtbase
, qttools
, pkgconfig
, lib
}:

stdenv.mkDerivation rec {
  name = "seamly2d-${version}";
  version = "0.6.0.1";

  src = fetchFromGitHub {
    owner = "FashionFreedom";
    repo = "Seamly2D";
    rev = "v${version}";
    sha256 = "1pghb2ssl04fk5jwffgn840ipk4nyicr2vbm8n9bxxr2hp6sndc3";
  };

  patches = [ ./replace-usr-share-with-constant.patch ];

  qmakeFlags = [ "CONFIG+=noDebugSymbols" "CONFIG+=no_ccache" ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags DEFINES+=NIXPKG_SHARE='\\\\\"$out/share\\\\\"' DEFINES+=NIXPKG_PDFTOPS='\\\\\"${xpdf}/bin/pdftops\\\\\"'"

    sed -i -e "s,\$\$\\[QT_INSTALL_HEADERS\\]/QtXmlPatterns,${qtxmlpatterns.dev}/include/," \
           -e "s,\$\$\\[QT_INSTALL_HEADERS\\]/QtSvg,${qtsvg.dev}/include/," \
      common.pri

    sed -i -e "s,\$\$\\[QT_INSTALL_HEADERS\\],${qtbase.dev}/include/," \
      common.pri

    sed -i -e "s,\$\$\\[QT_INSTALL_BINS\\],${qtbase.dev}/bin," \
      src/app/valentina/valentina.pro

    sed -i -e "s,\$\$\\[QT_INSTALL_BINS\\],${qtbase.dev}/bin," \
      src/app/tape/tape.pro \

    sed -i -e "s,/usr/share/valentina/,$out/share/valentina/," \
      src/app/tape/tape.pro

    sed -i -e "s,\$\$\\[QT_INSTALL_BINS\\]/\$\$LRELEASE,${qttools.dev}/bin/lrelease," \
      src/app/translations.pri

    sed -i -e "s,/usr/share,$out/share," \
      src/app/valentina/valentina.pro
  '';

  preFixup = ''rm -rf "$(pwd)" && mkdir "$(pwd)"'';

  nativeBuildInputs = [ pkgconfig qmake ];

  buildInputs = [ qttools qtbase qtsvg qtxmlpatterns ];

  meta = with stdenv.lib; {
    description = "Open source patternmaking software";
    homepage = https://fashionfreedom.eu;
    license = with licenses; [ gpl3 ];
    platforms = platforms.linux;
  };
}
