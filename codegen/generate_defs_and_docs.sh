#!/bin/bash

# atkmm/codegen/generate_defs_and_docs.sh

# This script must be executed from directory atkmm/codegen.

# Assumed directory structure:
#   glibmm/tools/defs_gen/docextract_to_xml.py
#   glibmm/tools/defs_gen/h2def.py
#   glibmm/tools/enum.pl
#   atk/atk/*.h atk/build/atk/*.h
#   atk/atk/*.c atk/build/atk/*.c
#   atkmm/codegen/extradefs/generate_extra_defs

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
# 4. Like step 2 when updating only the nly the docs.xml and .defs files.

GLIBMM_TOOLS_DIR=../../glibmm/tools
ATK_DIR=../../atk
ATKMM_ATK_SRC_DIR=../atk/src

if [ $# -eq 0 ]
then
  $GLIBMM_TOOLS_DIR/defs_gen/docextract_to_xml.py \
    --with-properties --no-recursion \
    -s $ATK_DIR/atk -s $ATK_DIR/build/atk \
    >$ATKMM_ATK_SRC_DIR/atk_docs.xml

  shopt -s nullglob # Skip a filename pattern that matches no file

  $GLIBMM_TOOLS_DIR/enum.pl \
    $ATK_DIR/atk/*.h $ATK_DIR/build/atk/*.h \
    >$ATKMM_ATK_SRC_DIR/atk_enums.defs

  $GLIBMM_TOOLS_DIR/defs_gen/h2def.py \
    $ATK_DIR/atk/*.h $ATK_DIR/build/atk/*.h \
    >$ATKMM_ATK_SRC_DIR/atk_methods.defs

  extradefs/generate_extra_defs \
    >$ATKMM_ATK_SRC_DIR/atk_signals.defs
  # patch version 2.7.5 does not like directory names.
  cd "$ATKMM_ATK_SRC_DIR"
  PATCH_OPTIONS="--backup --version-control=simple --suffix=.orig"
  patch $PATCH_OPTIONS atk_signals.defs atk_signals.defs.patch
elif [ "$1" = "--make-patch" ]
then
  ATKMM_ATK_SRC_DIR_FILE=$ATKMM_ATK_SRC_DIR/atk_signals.defs
  diff --unified=5 $ATKMM_ATK_SRC_DIR_FILE.orig $ATKMM_ATK_SRC_DIR_FILE > $ATKMM_ATK_SRC_DIR_FILE.patch
else
  echo "Usage: $0 [--make-patch]"
  exit 1
fi
