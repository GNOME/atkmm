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

# For now, gtkmm ships with a copy of the atkmm conversion specifications,
# thus the M4 files are not installed with atkmm.
# In order to change that, all depending packages will have to be modified
# as well, since for M4 files we do not have a mechanism like pkg-config for
# resolving module dependencies and building an include path automatically.
dist_noinst_DATA = $(addprefix m4/,$(files_codegen_m4))
noinst_PROGRAMS  = extradefs/generate_extra_defs

extradefs_generate_extra_defs_SOURCES = extradefs/generate_extra_defs_atk.cc
extradefs_generate_extra_defs_LDADD   = $(ATKMM_LIBS) -lglibmm_generate_extra_defs-2.4
extradefs_generate_extra_defs_LDFLAGS = -no-undefined -avoid-version

AM_CPPFLAGS = -I$(top_builddir) $(GTHREAD_CFLAGS) $(ATKMM_CFLAGS)
AM_CXXFLAGS = $(ATKMM_WXXFLAGS)

# Instruct GNU make to delete the targets of a rule after it failed, in
# order to avoid the complication of handling that situation manually.
.DELETE_ON_ERROR:
