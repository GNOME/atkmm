# NMake Makefile portion for code generation and
# intermediate build directory creation
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.

# Create the build directories
vs$(PDBVER)\$(CFG)\$(PLAT)\gendef	\
vs$(PDBVER)\$(CFG)\$(PLAT)\atkmm:
	@-mkdir $@

# Generate .def files
vs$(PDBVER)\$(CFG)\$(PLAT)\atkmm\atkmm.def: $(GENDEF) vs$(PDBVER)\$(CFG)\$(PLAT)\atkmm $(atkmm_OBJS)
	vs$(PDBVER)\$(CFG)\$(PLAT)\gendef.exe $@ $(ATKMM_LIBNAME) vs$(PDBVER)\$(CFG)\$(PLAT)\atkmm\*.obj

# Generate pre-generated resources and configuration headers (builds from GIT)
prep-git-build: pkg-ver.mak

atkmm\atkmm.rc: pkg-ver.mak atkmm\atkmm.rc.in
	@echo Generating $@...
	@copy $@.in $@
	@$(PERL) -pi.bak -e "s/\@ATKMM_MAJOR_VERSION\@/$(PKG_MAJOR_VERSION)/g" $@
	@$(PERL) -pi.bak -e "s/\@ATKMM_MINOR_VERSION\@/$(PKG_MINOR_VERSION)/g" $@
	@$(PERL) -pi.bak -e "s/\@ATKMM_MICRO_VERSION\@/$(PKG_MICRO_VERSION)/g" $@
	@$(PERL) -pi.bak -e "s/\@PACKAGE_VERSION\@/$(PKG_MAJOR_VERSION).$(PKG_MINOR_VERSION).$(PKG_MICRO_VERSION)/g" $@
	@$(PERL) -pi.bak -e "s/\@ATKMM_MODULE_NAME\@/atkmm-$(ATKMM_MAJOR_VERSION).$(ATKMM_MINOR_VERSION)/g" $@
	@del $@.bak

# You may change ATKMM_STATIC_LIB if you know what you are doing
atkmm\atkmmconfig.h: pkg-ver.mak ..\atk\atkmmconfig.h.in
	@echo Generating $@...
	@copy ..\atk\$(@F).in $@
	@$(PERL) -pi.bak -e "s/\#undef ATKMM_STATIC_LIB/\/\* \#undef ATKMM_STATIC_LIB \*\//g" $@
	@$(PERL) -pi.bak -e "s/\#undef ATKMM_MAJOR_VERSION/\#define ATKMM_MAJOR_VERSION $(PKG_MAJOR_VERSION)/g" $@
	@$(PERL) -pi.bak -e "s/\#undef ATKMM_MINOR_VERSION/\#define ATKMM_MINOR_VERSION $(PKG_MINOR_VERSION)/g" $@
	@$(PERL) -pi.bak -e "s/\#undef ATKMM_MICRO_VERSION/\#define ATKMM_MICRO_VERSION $(PKG_MICRO_VERSION)/g" $@
	@del $@.bak

pkg-ver.mak: ..\configure.ac
	@echo Generating version info Makefile Snippet...
	@$(PERL) -ne "print if /AC_INIT\(/" $** |	\
	$(PERL) -pe "tr/, /\n/s" |	\
	$(PERL) -ne "print if 2 .. 2" |	\
	$(PERL) -ne "print /\[(.*)\]/" > ver.txt
	@echo @echo off>pkg-ver.bat
	@echo.>>pkg-ver.bat
	@echo set /p atkmm_ver=^<ver.txt>>pkg-ver.bat
	@echo for /f "tokens=1,2,3 delims=." %%%%a IN ("%atkmm_ver%") do (echo PKG_MAJOR_VERSION=%%%%a^& echo PKG_MINOR_VERSION=%%%%b^& echo PKG_MICRO_VERSION=%%%%c)^>$@>>pkg-ver.bat
	@pkg-ver.bat
	@del ver.txt pkg-ver.bat
	$(MAKE) /f Makefile.vc CFG=$(CFG) GENERATE_VERSIONED_FILES=1 atkmm\atkmm.rc atkmm\atkmmconfig.h
