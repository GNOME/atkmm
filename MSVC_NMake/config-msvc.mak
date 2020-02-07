# NMake Makefile portion for enabling features for Windows builds

# These are the base minimum libraries required for building atkmm.
BASE_INCLUDES =	/I$(PREFIX)\include

# Please do not change anything beneath this line unless maintaining the NMake Makefiles
ATK_API_VERSION = 1.0
GLIB_API_VERSION = 2.0

ATKMM_MAJOR_VERSION = 1
ATKMM_MINOR_VERSION = 6

GLIBMM_MAJOR_VERSION = 2
GLIBMM_MINOR_VERSION = 4

LIBSIGC_MAJOR_VERSION = 2
LIBSIGC_MINOR_VERSION = 0

!if "$(CFG)" == "debug" || "$(CFG)" == "Debug"
DEBUG_SUFFIX = -d
!else
DEBUG_SUFFIX =
!endif

ATKMM_BASE_CFLAGS =			\
	/I..\atk /I.\atkmm		\
	/wd4530 /EHsc	\
	/FImsvc_recommended_pragmas.h

!if $(PDBVER) > 12
ATKMM_BASE_CFLAGS = $(ATKMM_BASE_CFLAGS) /utf-8
!endif

ATKMM_EXTRA_INCLUDES =	\
	/I$(PREFIX)\include\atk-$(ATK_API_VERSION)	\
	/I$(PREFIX)\include\glibmm-$(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)	\
	/I$(PREFIX)\lib\glibmm-$(GLIBMM_MAJOR_VERSION).$(GLIBMM_MINOR_VERSION)\include	\
	/I$(PREFIX)\include\glib-$(GLIB_API_VERSION)	\
	/I$(PREFIX)\lib\glib-$(GLIB_API_VERSION)\include	\
	/I$(PREFIX)\include\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)	\
	/I$(PREFIX)\lib\sigc++-$(LIBSIGC_MAJOR_VERSION).$(LIBSIGC_MINOR_VERSION)\include

ATKMM_CFLAGS = /DATKMM_BUILD $(ATKMM_BASE_CFLAGS) $(ATKMM_EXTRA_INCLUDES)

# We build atkmm-vc$(PDBVER)0-$(ATKMM_MAJOR_VERSION)_$(ATKMM_MINOR_VERSION).dll or
#          atkmm-vc$(PDBVER)0-d-$(ATKMM_MAJOR_VERSION)_$(ATKMM_MINOR_VERSION).dll at least

GLIBMM_LIBNAME = glibmm-vc$(PDBVER)0$(DEBUG_SUFFIX)-$(GLIBMM_MAJOR_VERSION)_$(GLIBMM_MINOR_VERSION)
LIBSIGC_LIBNAME = sigc-vc$(PDBVER)0$(DEBUG_SUFFIX)-$(LIBSIGC_MAJOR_VERSION)_$(LIBSIGC_MINOR_VERSION)

GLIBMM_DLL = $(GLIBMM_LIBNAME).dll
GLIBMM_LIB = $(GLIBMM_LIBNAME).lib
LIBSIGC_DLL = $(LIBSIGC_LIBNAME).dll
LIBSIGC_LIB = $(LIBSIGC_LIBNAME).lib

ATKMM_LIBNAME = atkmm-vc$(PDBVER)0$(DEBUG_SUFFIX)-$(ATKMM_MAJOR_VERSION)_$(ATKMM_MINOR_VERSION)

ATKMM_DLL = vs$(PDBVER)\$(CFG)\$(PLAT)\$(ATKMM_LIBNAME).dll
ATKMM_LIB = vs$(PDBVER)\$(CFG)\$(PLAT)\$(ATKMM_LIBNAME).lib

GENDEF = vs$(PDBVER)\$(CFG)\$(PLAT)\gendef.exe
GOBJECT_LIBS = gobject-$(GLIB_API_VERSION).lib glib-$(GLIB_API_VERSION).lib

ATK_LIBS = atk-$(ATK_API_VERSION).lib $(GOBJECT_LIBS)

ATKMM_BUILD_PRIVATE_HEADERS = $(atkmm_files_built_h:.h=_p.h)