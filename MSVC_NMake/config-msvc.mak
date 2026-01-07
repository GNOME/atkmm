# NMake Makefile portion for enabling features for Windows builds

# These are the base minimum libraries required for building atkmm.
!ifndef BASE_INCLUDEDIR
BASE_INCLUDEDIR = $(PREFIX)\include
!endif
!ifndef BASE_LIBDIR
BASE_LIBDIR = $(PREFIX)\lib
!endif

# Please do not change anything beneath this line unless maintaining the NMake Makefiles
ATK_API_VERSION = 1.0
ATKMM_MAJOR_VERSION = 1
ATKMM_MINOR_VERSION = 6
ATKMM_API_VERSION = $(ATKMM_MAJOR_VERSION).$(ATKMM_MINOR_VERSION)

GLIB_API_VERSION = 2.0
GLIBMM_MAJOR_VERSION = 2
GLIBMM_MINOR_VERSION = 4
GLIBMM_API_VERSION = $(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)

SIGC_MAJOR_VERSION = 2
SIGC_MINOR_VERSION = 0
SIGC_SERIES = $(SIGC_MAJOR_VERSION).$(SIGC_MINOR_VERSION)

OUTDIR = vs$(VSVER)\$(CFG)\$(PLAT)
DEPS_MKFILE = deps-vs$(VSVER)-$(PLAT)-$(CFG).mak
M4_PATH_MKFILE = find-m4-bindir-vs$(VSVER)-$(PLAT)-$(CFG).mak
UNIX_TOOLS_PATH_MKFILE = check-unix-tools-bindir-vs$(VSVER)-$(PLAT)-$(CFG).mak
GENERATE_CHECK_HEADER_BAT = gen-check-header-vs$(VSVER)-$(PLAT)-$(CFG).bat

# Gather up dependencies for their include directories and lib/bin dirs.
!if [for %t in (ATK GLIBMM SIGC GLIB) do @(echo !ifndef %t_INCLUDEDIR>>$(DEPS_MKFILE) & echo %t_INCLUDEDIR=^$^(BASE_INCLUDEDIR^)>>$(DEPS_MKFILE) & echo !endif>>$(DEPS_MKFILE))]
!endif
!if [for %t in (ATK GLIBMM SIGC GLIB) do @(echo !ifndef %t_LIBDIR>>$(DEPS_MKFILE) & echo %t_LIBDIR=^$^(BASE_LIBDIR^)>>$(DEPS_MKFILE) & echo !endif>>$(DEPS_MKFILE))]
!endif

!include $(DEPS_MKFILE)

!if [del /f/q $(DEPS_MKFILE)]
!endif

!if "$(CFG)" == "debug" || "$(CFG)" == "Debug"
DEBUG_SUFFIX = -d
!else
DEBUG_SUFFIX =
!endif

!ifndef M4
!ifdef UNIX_TOOLS_BINDIR
M4 = $(UNIX_TOOLS_BINDIR)\m4.exe
!else
M4 = m4
!endif
!endif

# Try to deduce full path to m4.exe, as needed
!if [if not exist $(M4)\ if exist $(M4) echo M4_FULL_PATH = $(M4)>$(M4_PATH_MKFILE)]
!endif
!if [if exist $(M4).exe echo M4_FULL_PATH = $(M4).exe>$(M4_PATH_MKFILE)]
!endif
!if [if not exist $(M4_PATH_MKFILE) ((echo M4_FULL_PATH = \>$(M4_PATH_MKFILE)) & where $(M4)>>$(M4_PATH_MKFILE) 2>NUL)]
!endif

!include $(M4_PATH_MKFILE)

!if [del /f/q $(M4_PATH_MKFILE)]
!endif

!if [if not "$(UNIX_TOOLS_BINDIR)" == "" if not "$(M4_FULL_PATH)" == "" echo UNIX_TOOLS_BINDIR_CHECKED = $(UNIX_TOOLS_BINDIR)>$(UNIX_TOOLS_PATH_MKFILE)]
!endif

!if [if "$(UNIX_TOOLS_BINDIR)" == "" if not "$(M4_FULL_PATH)" == "" (for %f in ($(M4_FULL_PATH)) do @echo UNIX_TOOLS_BINDIR_CHECKED = %~dpf>$(UNIX_TOOLS_PATH_MKFILE))]
!endif

!if [if not exist $(UNIX_TOOLS_PATH_MKFILE) (echo UNIX_TOOLS_BINDIR_CHECKED = >$(UNIX_TOOLS_PATH_MKFILE))]
!endif

!include $(UNIX_TOOLS_PATH_MKFILE)

!if [del /f/q $(UNIX_TOOLS_PATH_MKFILE)]
!endif

!ifndef GMMPROC_DIR
GMMPROC_DIR=$(GLIBMM_LIBDIR)\glibmm-$(GLIBMM_API_VERSION)\proc
!endif

DEP_CFLAGS =	\
	/I$(ATK_INCLUDEDIR)\atk-$(ATK_API_VERSION)	\
	/I$(GLIBMM_INCLUDEDIR)\giomm-$(GLIBMM_API_VERSION)	\
	/I$(GLIBMM_LIBDIR)\giomm-$(GLIBMM_API_VERSION)\include	\
	/I$(GLIBMM_INCLUDEDIR)\glibmm-$(GLIBMM_API_VERSION)	\
	/I$(GLIBMM_LIBDIR)\glibmm-$(GLIBMM_API_VERSION)\include	\
	/I$(SIGC_INCLUDEDIR)\sigc++-$(SIGC_SERIES)	\
	/I$(SIGC_LIBDIR)\sigc++-$(SIGC_SERIES)\include	\
	/I$(GLIB_INCLUDEDIR)\glib-$(GLIB_API_VERSION)	\
	/I$(GLIB_LIBDIR)\glib-$(GLIB_API_VERSION)\include	\
	/I$(BASE_INCLUDEDIR)

ATKMM_BASE_CFLAGS = /FImsvc_recommended_pragmas.h

ATKMM_INCLUDES =	\
	/I$(OUTDIR)	\
	/I..\untracked\atk	\
	/I..\atk /I.\atkmm	\
	$(DEP_CFLAGS)

ATKMM_CFLAGS = /DATKMM_BUILD $(ATKMM_BASE_CFLAGS)

# We build atkmm-vc$(VSVER_LIB)-$(ATKMM_MAJOR_VERSION)_$(ATKMM_MINOR_VERSION).dll or
#          atkmm-vc$(VSVER_LIB)-d-$(ATKMM_MAJOR_VERSION)_$(ATKMM_MINOR_VERSION).dll at least

!if "$(USE_COMPAT_LIBS)" != ""
VSVER_LIB = 140
MESON_VSVER_LIB =
!else
VSVER_LIB = $(PDBVER)$(VSVER_SUFFIX)
MESON_VSVER_LIB = -vc$(VSVER_LIB)
!endif

!ifdef USE_MESON_LIBS
SIGC_LIBNAME = sigc-$(SIGC_SERIES)
GLIBMM_LIBNAME = glibmm$(MESON_VSVER_LIB)-$(GLIBMM_API_VERSION)
ATKMM_LIBNAME = atkmm$(MESON_VSVER_LIB)-$(ATKMM_API_VERSION)

ATKMM_DLLNAME = $(ATKMM_LIBNAME)-1
!else
SIGC_LIBNAME = sigc-vc$(PDBVER)0$(DEBUG_SUFFIX)-$(SIGC_SERIES:.=_)
GLIBMM_LIBNAME = glibmm-vc$(VSVER_LIB)$(DEBUG_SUFFIX)-$(GLIBMM_API_VERSION:.=_)
ATKMM_LIBNAME = atkmm-vc$(VSVER_LIB)$(DEBUG_SUFFIX)-$(ATKMM_API_VERSION:.=_)

ATKMM_DLLNAME = $(ATKMM_LIBNAME)
!endif

SIGC_LIB = $(SIGC_LIBNAME).lib
GLIBMM_LIB = $(GLIBMM_LIBNAME).lib

ATKMM_DLL = $(OUTDIR)\$(ATKMM_DLLNAME).dll
ATKMM_LIB = $(OUTDIR)\$(ATKMM_LIBNAME).lib

GENDEF = $(OUTDIR)\gendef.exe
GOBJECT_LIBS = gobject-$(GLIB_API_VERSION).lib glib-$(GLIB_API_VERSION).lib

ATKMM_BUILD_PRIVATE_HEADERS = $(atkmm_files_built_h:.h=_p.h)
ATK_LIB = atk-1.0.lib

DEP_LDFLAGS = $(SIGC_LIB) /libpath:$(BASE_LIBDIR)
!if "$(SIGC_LIBDIR)" != "$(BASE_LIBDIR)"
DEP_LDFLAGS = /libpath:$(SIGC_LIBDIR) $(DEP_LDFLAGS)
!endif
DEP_LDFLAGS = $(GLIBMM_LIB) $(DEP_LDFLAGS)
!if "$(GLIBMM_LIBDIR)" != "$(BASE_LIBDIR)"
DEP_LDFLAGS = /libpath:$(GLIBMM_LIBDIR) $(DEP_LDFLAGS)
!endif
DEP_LDFLAGS = $(GOBJECT_LIBS) $(DEP_LDFLAGS)
!if "$(GLIB_LIBDIR)" != "$(BASE_LIBDIR)"
DEP_LDFLAGS = /libpath:$(GLIB_LIBDIR) $(DEP_LDFLAGS)
!endif
DEP_LDFLAGS = $(ATK_LIB) $(DEP_LDFLAGS)
!if "$(ATK_LIBDIR)" != "$(BASE_LIBDIR)"
DEP_LDFLAGS = /libpath:$(ATK_LIBDIR) $(DEP_LDFLAGS)
!endif
