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

# Although atkmm is no longer part of the gtkmm module, it still has the same
# pkg-config name as before and is meant to be binary compatible.  Thus for the
# time being, the version number cannot be brought in line with ATK, since that
# would break compatibility.
AC_INIT([atkmm], [2.36.3], [https://gitlab.gnome.org/GNOME/atkmm/issues/],
        [atkmm], [https://gtkmm.gnome.org/])
AC_PREREQ([2.59])

AC_CONFIG_SRCDIR([atk/atkmm.h])
AC_CONFIG_AUX_DIR([build])
AC_CONFIG_MACRO_DIR([build])
AC_CONFIG_HEADERS([build/config.h atk/atkmmconfig.h])

AM_INIT_AUTOMAKE([1.9 -Wno-portability dist-bzip2 no-define nostdinc tar-pax foreign])
# Support silent build rules.
# Disable by either passing --disable-silent-rules to configure or passing V=1 to make.
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
AM_MAINTAINER_MODE
AC_ARG_VAR([ACLOCAL_FLAGS], [aclocal flags, e.g. -I <macro dir>])

MM_PREREQ([0.9.12])
MM_INIT_MODULE([atkmm-2.36])

# Copy the mm-common .pl scripts into doc/, and use them from there,
# so we can dist them to avoid a tarball-build dependency.
MM_CONFIG_DOCTOOL_DIR([doc])

# http://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html
AC_SUBST([ATKMM_SO_VERSION], [2:0:1])
AC_SUBST([MSVC_TOOLSET_VER], [''])

AC_PROG_CXX
MM_AX_CXX_COMPILE_STDCXX([17], [noext], [mandatory])

AC_DISABLE_STATIC
LT_INIT([win32-dll])

AC_SUBST([ATKMM_MODULES], ['atk >= 2.33.3 glibmm-2.68 >= 2.68.0'])
PKG_CHECK_MODULES([ATKMM], [$ATKMM_MODULES])

MM_PKG_CONFIG_SUBST([GTHREAD_CFLAGS], [--cflags-only-other gthread-2.0])
MM_PKG_CONFIG_SUBST([GMMPROC_DIR], [--variable=gmmprocdir glibmm-2.68])

MM_ARG_DISABLE_DEPRECATED_API

MM_ARG_ENABLE_DOCUMENTATION
MM_ARG_WITH_TAGFILE_DOC([libstdc++.tag], [mm-common-libstdc++])
MM_ARG_WITH_TAGFILE_DOC([libsigc++-3.0.tag], [sigc++-3.0])
MM_ARG_WITH_TAGFILE_DOC([glibmm-2.68.tag], [glibmm-2.68])

AC_LANG([C++])
MM_ARG_ENABLE_WARNINGS([ATKMM_WXXFLAGS],
                       [-Wall],
                       [-pedantic -Wall -Wextra -Wformat-security -Wsuggest-override -Wshadow -Wno-long-long],
                       [G ATK GLIBMM])

AC_CONFIG_FILES([Makefile
                 codegen/Makefile
                 atk/${ATKMM_MODULE_NAME}.pc:atk/atkmm.pc.in
                 atk/${ATKMM_MODULE_NAME}-uninstalled.pc:atk/atkmm-uninstalled.pc.in
                 atk/src/Makefile
                 atk/atkmm/Makefile
                 doc/Makefile
                 doc/reference/Doxyfile
                 MSVC_NMake/atkmm/atkmm.rc])

# Copy the generated configuration headers into the MSVC project directories.
AC_CONFIG_COMMANDS([MSVC_NMake/atkmm/atkmmconfig.h],
                   [cp -f atk/atkmmconfig.h MSVC_NMake/atkmm/atkmmconfig.h])
AC_OUTPUT
