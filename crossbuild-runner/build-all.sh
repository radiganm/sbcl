#!/bin/sh

set -e
# This script just checks that it's possible to build and run
# the cross-compiler for all backends using a predetermined
# 'local-target-features' for each.
# There is no dependence on the C runtime,
# since we don't assume the presence of either a C cross-compiler
# or a host machine on which to run its native compiler.

# FIXME: hppa
for arch in alpha arm arm64 mips ppc sparc x86 x86-64
do
  echo TESTING $arch
  ltf=local-target-features.lisp-expr
  echo '(lambda (features) (union features (list :crossbuild-test ' > $ltf
  cat crossbuild-runner/backends/$arch/local-target-features >> $ltf
  echo ')))' >> $ltf

  cp -fv crossbuild-runner/backends/$arch/stuff-groveled-from-headers.lisp \
         output/stuff-groveled-from-headers.lisp
  sh make-host-1.sh
  sh make-host-2.sh
done
