#!/bin/bash

# atkmm/codegen/generate_defs_and_docs.sh

# Global environment variables:
# GMMPROC_GEN_SOURCE_DIR  Top directory where source files are searched for.
#                         Default value: $(dirname "$0")/../..
#                         i.e. 2 levels above this file.
# GMMPROC_GEN_BUILD_DIR   Top directory where built files are searched for.
#                         Default value: $GMMPROC_GEN_SOURCE_DIR
#
# If you use jhbuild, you can set these environment variables equal to jhbuild's
# configuration variables checkoutroot and buildroot, respectively.
# Usually you can leave GMMPROC_GEN_SOURCE_DIR undefined.
# If you have set buildroot=None, GMMPROC_GEN_BUILD_DIR can also be undefined.

# Generated files:
#   atkmm/atk/src/atk_docs.xml
#   atkmm/atk/src/atk_enums.defs
#   atkmm/atk/src/atk_methods.defs
#   atkmm/atk/src/atk_signals.defs

# To update the atk_docs.xml file and the .defs files:
# 1. ./generate_defs_and_docs.sh
#    Generates atk/src/atk_signals.defs.orig and atk/src/atk_signals.defs.
#    If any hunks from the patch file fail to apply, apply them manually to the
#    atk_signals.defs file, if required.
# 2. Optional: Remove atk/src/atk_signals.defs.orig.

# To update the atk_signals.defs file and the patch file:
# 1. Like step 1 when updating only the docs.xml and .defs files.
# 2. Apply new patches manually to the atk_signals.defs file.
# 3. ./generate_defs_and_docs.sh --make-patch
# 4. Like step 2 when updating only the docs.xml and .defs files.

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

# Scripts in glibmm. These are source files.
gen_docs="$GMMPROC_GEN_SOURCE_DIR/glibmm/tools/defs_gen/docextract_to_xml.py"
gen_methods="$GMMPROC_GEN_SOURCE_DIR/glibmm/tools/defs_gen/h2def.py"
gen_enums="$GMMPROC_GEN_SOURCE_DIR/glibmm/tools/enum.pl"

# Where to find the executable that generates extra defs (signals and properties).
# atkmm is built with meson or autotools. Don't require, non-source-dir builds.
extra_defs_gen_dir="$GMMPROC_GEN_BUILD_DIR/atkmm/codegen/extradefs"

source_prefix="$GMMPROC_GEN_SOURCE_DIR/at-spi2-core"
build_prefix="$GMMPROC_GEN_BUILD_DIR/at-spi2-core"
if [ "$source_prefix" == "$build_prefix" ]; then
  # atk is built with meson, which requires non-source-dir builds.
  # This is what jhbuild does, if necessary, to force non-source-dir builds.
  build_prefix="$build_prefix/build"
fi

out_dir="$root_dir/atk/src"
signals_out_file=atk_signals.defs
signals_out_dir_file="$out_dir"/$signals_out_file

if [ $# -eq 0 ]; then
  # Documentation
  echo === atk_docs.xml ===
  params="--with-properties --no-recursion"
  for dir in "$source_prefix/atk" "$build_prefix/atk"; do
    if [ -d "$dir" ]; then
      params="$params -s $dir"
    fi
  done
  "$gen_docs" $params > "$out_dir/atk_docs.xml"

  shopt -s nullglob # Skip a filename pattern that matches no file

  # Enums
  echo === atk_enums.defs ===
  "$gen_enums" "$source_prefix"/atk/*.h "$build_prefix"/atk/*.h  > "$out_dir/atk_enums.defs"

  # Functions and methods
  echo === atk_methods.defs ===
  "$gen_methods" "$source_prefix"/atk/*.h "$build_prefix"/atk/*.h  > "$out_dir/atk_methods.defs"

  # Properties and signals
  echo === $signals_out_file ===
  "$extra_defs_gen_dir"/generate_extra_defs > "$signals_out_dir_file"
  # patch version 2.7.5 does not like directory names.
  cd "$out_dir"
  patch_options="--backup --version-control=simple --suffix=.orig"
  patch $patch_options $signals_out_file $signals_out_file.patch
elif [ "$1" == "--make-patch" ]; then
  diff --unified=5 "$signals_out_dir_file".orig "$signals_out_dir_file" > "$signals_out_dir_file".patch
else
  echo "Usage: $0 [--make-patch]"
  exit 1
fi
