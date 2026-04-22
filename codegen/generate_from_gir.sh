#!/bin/bash

# atkmm/codegen/generate_from_gir.sh

# Global environment variables:
# GMMPROC_GEN_SOURCE_DIR  Top directory where source files are searched for.
#                         Default value: $(dirname "$0")/../..
#                         i.e. 2 levels above this file.
# GMMPROC_GEN_BUILD_DIR   Top directory where built files are searched for.
#                         Default value: $GMMPROC_GEN_SOURCE_DIR
# GMMPROC_GEN_INSTALL_DIR Top directory where installed files are searched for.
#                         Default value: $HOME/jhbuild/install
#
# If you use jhbuild, you can set these environment variables equal to jhbuild's
# configuration variables checkoutroot, buildroot and prefix, respectively.
# Usually you can leave GMMPROC_GEN_SOURCE_DIR undefined.
# If you have set buildroot=None, GMMPROC_GEN_BUILD_DIR can be undefined.
# If you have not defined prefix in $HOME/.config/jhbuildrc, and there is no /opt/gnome
# directory, GMMPROC_GEN_INSTALL_DIR can be undefined.

# Generated files:
#   atkmm/atk/src/atk_docs.xml
#   atkmm/atk/src/atk_enums.defs
#   atkmm/atk/src/atk_methods.defs
#   atkmm/atk/src/atk_signals.defs
#   atkmm/atk/src/atk_vfuncs.defs

# To update the atk_docs.xml file and the .defs files:
# 1. ./generate_from_gir.sh
#    Generates atk/src/atk_*.defs.orig and atk/src/atk_*.defs.
#    If any hunks from the patch files fail to apply, apply them manually to
#    the defs files, if required.
# 2. Optional: Remove atk/src/atk_*.defs.orig.

# To update the patch files:
# 1. Like step 1 when updating the docs.xml and .defs files.
# 2. Apply new patches manually to the atk_*.defs file.
# 3. ./generate_from_gir.sh --make-patch
# 4. Like step 2 when updating the docs.xml and .defs files.

# Root directory of atkmm source files.
root_dir="$(dirname "$0")/.."

# Where to search for source files.
if [ -z "$GMMPROC_GEN_SOURCE_DIR" ]; then
  GMMPROC_GEN_SOURCE_DIR="$root_dir/.."
fi

# Where to search for built files.
if [ -z "$GMMPROC_GEN_BUILD_DIR" ]; then
  GMMPROC_GEN_BUILD_DIR="$GMMPROC_GEN_SOURCE_DIR"
fi

# Where to search for installed files.
if [ -z "$GMMPROC_GEN_INSTALL_DIR" ]; then
  GMMPROC_GEN_INSTALL_DIR="$HOME/jhbuild/install"
fi

# Script in glibmm. This is a source file.
gen_docs="$GMMPROC_GEN_SOURCE_DIR/glibmm/tools/defs_gen/docextract_to_xml.py"

# Where to find the executable that generates defs files from GIR files.
gen_with_mmgir="$GMMPROC_GEN_BUILD_DIR/glibmm/tools/mmgir/mmgir"

source_prefix="$GMMPROC_GEN_SOURCE_DIR/at-spi2-core"
build_prefix="$GMMPROC_GEN_BUILD_DIR/at-spi2-core"
if [ "$source_prefix" == "$build_prefix" ]; then
  # atk is built with meson, which requires non-source-dir builds.
  # This is what jhbuild does, if necessary, to force non-source-dir builds.
  build_prefix="$build_prefix/build"
fi

gir_dir="$GMMPROC_GEN_INSTALL_DIR/share/gir-1.0"
out_dir="$root_dir/atk/src"

if [ $# -eq 0 ]; then
  echo ===== Documentation
  params="--with-properties --no-recursion"
  for dir in "$source_prefix/atk" "$build_prefix/atk"; do
    if [ -d "$dir" ]; then
      params="$params -s $dir"
    fi
  done
  "$gen_docs" $params > "$out_dir/atk_docs.xml"

  echo; echo ===== Enums, methods, signals and vfuncs
  "$gen_with_mmgir" --gir "$gir_dir"/Atk-1.0.gir \
    --gir-search-dir "$gir_dir" \
    --enum-defs "$out_dir"/atk_enums.defs \
    --function-defs "$out_dir"/atk_methods.defs \
    --signal-defs "$out_dir"/atk_signals.defs \
    --vfunc-defs "$out_dir"/atk_vfuncs.defs

  echo; echo ===== Patching defs files
  patch_options="--backup --version-control=simple --suffix=.orig"
  # Execute in a subshell. The effect of the cd command is undone when the subshell ends.
  (
    cd "$out_dir"
    for file in atk_enums.defs atk_signals.defs atk_vfuncs.defs
    do
      patch $patch_options $file $file.girpatch
    done
  )
elif [ "$1" == "--make-patch" ]; then
  (
    cd "$out_dir"
    for file in atk_enums.defs atk_signals.defs atk_vfuncs.defs
    do
      diff --unified=5 $file.orig $file > $file.girpatch
    done
  )
else
  echo "Usage: $0 [--make-patch]"
  exit 1
fi
