#!/bin/bash

# atkmm/codegen/generate_defs_and_docs.sh

# This script must be executed from directory atkmm/codegen.

# Assumed directory structure:
#   glibmm/tools/defs_gen/docextract_to_xml.py
#   glibmm/tools/defs_gen/h2def.py
#   glibmm/tools/enum.pl
#   atk/atk/*.h
#   atk/atk/*.c
#   atkmm/codegen/extradefs/generate_extra_defs

# Generated files:
#   atkmm/atk/src/atk_docs.xml
#   atkmm/atk/src/atk_enums.defs
#   atkmm/atk/src/atk_methods.defs
#   atkmm/atk/src/atk_signals.defs

GLIBMM_TOOLS_DIR=../../glibmm/tools
ATK_DIR=../../atk
ATKMM_ATK_SRC_DIR=../atk/src

$GLIBMM_TOOLS_DIR/defs_gen/docextract_to_xml.py \
  -s $ATK_DIR/atk \
  >$ATKMM_ATK_SRC_DIR/atk_docs.xml

$GLIBMM_TOOLS_DIR/enum.pl \
  $ATK_DIR/atk/*.h \
  >$ATKMM_ATK_SRC_DIR/atk_enums.defs

$GLIBMM_TOOLS_DIR/defs_gen/h2def.py \
  $ATK_DIR/atk/*.h \
  >$ATKMM_ATK_SRC_DIR/atk_methods.defs

extradefs/generate_extra_defs \
  >$ATKMM_ATK_SRC_DIR/atk_signals.defs

