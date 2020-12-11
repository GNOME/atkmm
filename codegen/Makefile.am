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

AUTOMAKE_OPTIONS = subdir-objects

include $(srcdir)/m4/filelist.am

# Install m4 files for reuse by other *mm projects, when building from git:
# TODO: All these Perl scripts and M4 files are architecture-independent
# and should probably go somewhere below $(pkgdatadir) instead.
gmmproc_bindir = $(libdir)/$(ATKMM_MODULE_NAME)/proc
gmmproc_m4dir  = $(gmmproc_bindir)/m4
dist_gmmproc_m4_DATA = $(files_codegen_m4:%=m4/%)

dist_noinst_SCRIPTS = generate_defs_and_docs.sh
noinst_PROGRAMS  = extradefs/generate_extra_defs

extradefs_generate_extra_defs_SOURCES = extradefs/generate_extra_defs_atk.cc
extradefs_generate_extra_defs_LDADD   = $(ATKMM_LIBS) -lglibmm_generate_extra_defs-2.68
extradefs_generate_extra_defs_LDFLAGS = -no-undefined -avoid-version

AM_CPPFLAGS = -I$(top_builddir) $(GTHREAD_CFLAGS) $(ATKMM_CFLAGS)
AM_CXXFLAGS = $(ATKMM_WXXFLAGS)

# Instruct GNU make to delete the targets of a rule after it failed, in
# order to avoid the complication of handling that situation manually.
.DELETE_ON_ERROR:
