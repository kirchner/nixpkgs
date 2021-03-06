args @ { fetchurl, ... }:
rec {
  baseName = ''cxml-xml'';
  version = ''cxml-20110619-git'';

  testSystems = ["cxml"];

  description = '''';

  deps = [ args."trivial-gray-streams" args."puri" args."closure-common" ];

  src = fetchurl {
    url = ''http://beta.quicklisp.org/archive/cxml/2011-06-19/cxml-20110619-git.tgz'';
    sha256 = ''04k6syn9p7qsazi84kab9n9ki2pb5hrcs0ilw7wikxfqnbabm2yk'';
  };

  overrides = x: {
    postInstall = ''
      find "$out/lib/common-lisp/" -name '*.asd' | grep -iv '/cxml-xml[.]asd${"$"}' |
        while read f; do
          CL_SOURCE_REGISTRY= \
          NIX_LISP_PRELAUNCH_HOOK="nix_lisp_run_single_form '(asdf:load-system :$(basename "$f" .asd))'" \
            "$out"/bin/*-lisp-launcher.sh ||
          mv "$f"{,.sibling}; done || true
    '';
  };
}
/* (SYSTEM cxml-xml DESCRIPTION NIL SHA256 04k6syn9p7qsazi84kab9n9ki2pb5hrcs0ilw7wikxfqnbabm2yk URL
    http://beta.quicklisp.org/archive/cxml/2011-06-19/cxml-20110619-git.tgz MD5 587755dff60416d4f716f4e785cf747e NAME cxml-xml TESTNAME cxml FILENAME cxml-xml
    DEPS ((NAME trivial-gray-streams) (NAME puri) (NAME closure-common)) DEPENDENCIES (trivial-gray-streams puri closure-common) VERSION cxml-20110619-git
    SIBLINGS (cxml)) */
