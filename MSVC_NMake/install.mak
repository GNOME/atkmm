# NMake Makefile snippet for copying the built libraries, utilities and headers to
# a path under $(PREFIX).

install: all
	@if not exist $(PREFIX)\bin\ md $(PREFIX)\bin
	@if not exist $(PREFIX)\lib\atkmm-$(ATKMM_MAJOR_VERSION).$(ATKMM_MINOR_VERSION)\include\ md $(PREFIX)\lib\atkmm-$(ATKMM_MAJOR_VERSION).$(ATKMM_MINOR_VERSION)\include
	@if not exist $(PREFIX)\include\atkmm-$(ATKMM_MAJOR_VERSION).$(ATKMM_MINOR_VERSION)\atkmm\private\ @md $(PREFIX)\include\atkmm-$(ATKMM_MAJOR_VERSION).$(ATKMM_MINOR_VERSION)\atkmm\private
	@if not exist $(PREFIX)\share\atkmm-$(ATKMM_MAJOR_VERSION).$(ATKMM_MINOR_VERSION)\proc\ md $(PREFIX)\share\atkmm-$(ATKMM_MAJOR_VERSION).$(ATKMM_MINOR_VERSION)\proc
	@copy /b vs$(PDBVER)\$(CFG)\$(PLAT)\$(ATKMM_LIBNAME).dll $(PREFIX)\bin
	@copy /b vs$(PDBVER)\$(CFG)\$(PLAT)\$(ATKMM_LIBNAME).pdb $(PREFIX)\bin
	@copy /b vs$(PDBVER)\$(CFG)\$(PLAT)\$(ATKMM_LIBNAME).lib $(PREFIX)\lib
	@copy ..\atk\atkmm.h "$(PREFIX)\include\atkmm-$(ATKMM_MAJOR_VERSION).$(ATKMM_MINOR_VERSION)\"
	@for %h in ($(atkmm_files_extra_h)) do @copy ..\atk\atkmm\%h "$(PREFIX)\include\atkmm-$(ATKMM_MAJOR_VERSION).$(ATKMM_MINOR_VERSION)\atkmm\%h"
	@for %h in ($(atkmm_files_built_h)) do @copy ..\atk\atkmm\%h "$(PREFIX)\include\atkmm-$(ATKMM_MAJOR_VERSION).$(ATKMM_MINOR_VERSION)\atkmm\%h"
	@for %h in ($(ATKMM_BUILD_PRIVATE_HEADERS)) do @copy ..\atk\atkmm\private\%h "$(PREFIX)\include\atkmm-$(ATKMM_MAJOR_VERSION).$(ATKMM_MINOR_VERSION)\atkmm\private\%h"
	@copy ".\atkmm\atkmmconfig.h" "$(PREFIX)\lib\atkmm-$(ATKMM_MAJOR_VERSION).$(ATKMM_MINOR_VERSION)\include\"
	@copy ..\codegen\m4\*.m4 $(PREFIX)\share\atkmm-$(ATKMM_MAJOR_VERSION).$(ATKMM_MINOR_VERSION)\proc
