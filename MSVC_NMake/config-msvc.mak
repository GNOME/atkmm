# NMake Makefile portion for enabling features for Windows builds

# These are the base minimum libraries required for building glibmm.
BASE_INCLUDES =	/I$(PREFIX)\include

# Please do not change anything beneath this line unless maintaining the NMake Makefiles
ATK_API_VERSION = 1.0
ATKMM_MAJOR_VERSION = 2
ATKMM_MINOR_VERSION = 30

GLIB_API_VERSION = 2.0

LIBSIGC_MAJOR_VERSION = 3
LIBSIGC_MINOR_VERSION = 0
GLIBMM_MAJOR_VERSION = 2
GLIBMM_MINOR_VERSION = 66


!if "$(CFG)" == "debug" || "$(CFG)" == "Debug"
DEBUG_SUFFIX = -d
!else
DEBUG_SUFFIX =
!endif

ATKMM_BASE_CFLAGS =		\
	/I..\atk /I.\atkmm	\
	/wd4530 /std:c++17	\
	/utf-8	\
	/FImsvc_recommended_pragmas.h

ATKMM_EXTRA_INCLUDES =	\
	/I$(PREFIX)\include\atk-$(ATK_API_VERSION)	\
	/I$(PREFIX)\include\glibmm-$(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)	\
	/I$(PREFIX)\lib\glibmm-$(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)\include	\
	/I$(PREFIX)\include\glib-$(GLIB_API_VERSION)	\
	/I$(PREFIX)\lib\glib-$(GLIB_API_VERSION)\include	\
	/I$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)	\
	/I$(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include

LIBATKMM_CFLAGS = /DATKMM_BUILD $(ATKMM_BASE_CFLAGS) $(ATKMM_EXTRA_INCLUDES)

# We build atkmm-vc$(VSVER)0-$(ATKMM_MAJOR_VERSION)_$(ATKMM_MINOR_VERSION).dll or
#          atkmm-vc$(VSVER)0-d-$(ATKMM_MAJOR_VERSION)_$(ATKMM_MINOR_VERSION).dll at least

!ifdef USE_MESON_LIBS
LIBSIGC_LIBNAME = sigc-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)
LIBSIGC_DLL = $(LIBSIGC_LIBNAME)-0.dll
!else
LIBSIGC_LIBNAME = sigc-vc$(VSVER)0$(DEBUG_SUFFIX)-$(LIBSIGC_MAJOR_VERSION)_$(LIBSIGC_MINOR_VERSION)
LIBSIGC_DLL = $(LIBSIGC_LIBNAME).dll
!endif

LIBSIGC_LIB = $(LIBSIGC_LIBNAME).lib

GLIBMM_LIBNAME = glibmm-vc$(VSVER)0$(DEBUG_SUFFIX)-$(GLIBMM_MAJOR_VERSION)_$(GLIBMM_MINOR_VERSION)

GLIBMM_DLL = $(GLIBMM_LIBNAME).dll
GLIBMM_LIB = $(GLIBMM_LIBNAME).lib

ATKMM_LIBNAME = atkmm-vc$(VSVER)0$(DEBUG_SUFFIX)-$(ATKMM_MAJOR_VERSION)_$(ATKMM_MINOR_VERSION)

ATKMM_DLL = vs$(VSVER)\$(CFG)\$(PLAT)\$(ATKMM_LIBNAME).dll
ATKMM_LIB = vs$(VSVER)\$(CFG)\$(PLAT)\$(ATKMM_LIBNAME).lib

GENDEF = vs$(VSVER)\$(CFG)\$(PLAT)\gendef.exe
GOBJECT_LIBS = gobject-2.0.lib gmodule-2.0.lib glib-2.0.lib

ATK_LIBS = atk-1.0.lib $(GOBJECT_LIBS)
ATKMM_DEP_LIBS = $(GLIBMM_LIB) $(LIBSIGC_LIB) $(ATK_LIBS)
