## Copyright (c) 2010  Openismus GmbH  <http://www.openismus.com/>
##
## This file is part of atkmm.
##
## atkmm is free software: you can redistribute it and/or modify it
## under the terms of the GNU Lesser General Public License as published
## by the Free Software Foundation, either version 2.1 of the License,
## or (at your option) any later version.
##
## atkmm is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
## See the GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

ACLOCAL_AMFLAGS = -I build ${ACLOCAL_FLAGS}
DISTCHECK_CONFIGURE_FLAGS = --enable-warnings=fatal

if MAINTAINER_MODE
src_subdirs = atk/src
else
src_subdirs =
endif
if ENABLE_DOCUMENTATION
doc_subdirs = doc
else
doc_subdirs =
endif
SUBDIRS = codegen $(src_subdirs) atk/atkmm $(doc_subdirs)

atkmm_includedir = $(includedir)/$(ATKMM_MODULE_NAME)
atkmm_include_HEADERS = atk/atkmm.h

atkmm_libincludedir = $(libdir)/$(ATKMM_MODULE_NAME)/include
nodist_atkmm_libinclude_HEADERS = atk/atkmmconfig.h

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = atk/$(ATKMM_MODULE_NAME).pc

include $(srcdir)/MSVC_NMake/filelist.am

text_files = COPYING.tools README.md README.win32.md
msvc_files = $(addprefix MSVC_NMake/,$(msvc_nmake_data))

dist_noinst_DATA = $(text_files) $(msvc_files)
dist_noinst_SCRIPTS = autogen.sh

DISTCLEANFILES = $(filter %mmconfig.h,$(msvc_files))

# Distribute files needed when building atkmm with Meson.
EXTRA_DIST = \
  meson.build \
  meson_options.txt \
  MSVC_NMake/atkmm/meson.build \
  doc/reference/meson.build \
  atk/meson.build \
  atk/atkmm/meson.build \
  atk/atkmmconfig.h.meson \
  codegen/dummy-header.py \
  codegen/extradefs/meson.build \
  subprojects/atk.wrap \
  subprojects/glibmm-2.68.wrap \
  untracked/README

# Auto-generate the ChangeLog file from the git log on make dist
include $(top_srcdir)/build/dist-changelog.am
