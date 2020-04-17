# NMake Makefile portion for compilation rules
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.  The format
# of NMake Makefiles here are different from the GNU
# Makefiles.  Please see the comments about these formats.

# Inference rules for compiling the .obj files.
# Used for libs and programs with more than a single source file.
# Format is as follows
# (all dirs must have a trailing '\'):
#
# {$(srcdir)}.$(srcext){$(destdir)}.obj::
# 	$(CC)|$(CXX) $(cflags) /Fo$(destdir) /c @<<
# $<
# <<
{vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\}.obj::
	$(CXX) $(ATKMM_CFLAGS) $(CFLAGS_NOGL) /Fovs$(VSVER)\$(CFG)\$(PLAT)\atkmm\ /Fdvs$(VSVER)\$(CFG)\$(PLAT)\atkmm\ /c @<<
$<
<<

{..\untracked\atk\atkmm\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\}.obj::
	$(CXX) $(ATKMM_CFLAGS) $(CFLAGS_NOGL) /Fovs$(VSVER)\$(CFG)\$(PLAT)\atkmm\ /Fdvs$(VSVER)\$(CFG)\$(PLAT)\atkmm\ /c @<<
$<
<<

{..\atk\atkmm\}.cc{vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\}.obj::
	$(CXX) $(ATKMM_CFLAGS) $(CFLAGS_NOGL) /Fovs$(VSVER)\$(CFG)\$(PLAT)\atkmm\ /Fdvs$(VSVER)\$(CFG)\$(PLAT)\atkmm\ /c @<<
$<
<<

{..\atk\src\}.ccg{vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\}.obj:
	@if not exist $(@D)\private\ $(MAKE) /f Makefile.vc CFG=$(CFG) $(@D)\private
	@for %%s in ($(<D)\*.ccg) do @if not exist ..\atk\atkmm\%%~ns.cc if not exist $(@D)\%%~ns.cc $(PERL) -- $(GMMPROC_DIR)/gmmproc -I ../codegen/m4 --defs $(<D:\=/) %%~ns $(<D:\=/) $(@D)
	@if exist $(@D)\$(<B).cc $(CXX) $(ATKMM_CFLAGS) $(CFLAGS_NOGL) /Fo$(@D)\ /Fd$(@D)\ /c $(@D)\$(<B).cc
	@if exist ..\untracked\atk\atkmm\$(<B).cc $(CXX) $(ATKMM_CFLAGS) $(CFLAGS_NOGL) /Fo$(@D)\ /Fd$(@D)\ /c ..\untracked\atk\atkmm\$(<B).cc
	@if exist ..\atk\atkmm\$(<B).cc $(CXX) $(ATKMM_CFLAGS) $(CFLAGS_NOGL) /Fo$(@D)\ /Fd$(@D)\ /c ..\atk\atkmm\$(<B).cc

{.\atkmm\}.rc{vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\}.res:
	rc /fo$@ $<

# Rules for building .lib files
$(ATKMM_LIB): $(ATKMM_DLL)

# Rules for linking DLLs
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(dll_name_with_path): $(dependent_libs_files_objects_and_items)
#	link /DLL [$(linker_flags)] [$(dependent_libs)] [/def:$(def_file_if_used)] [/implib:$(lib_name_if_needed)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2
$(ATKMM_DLL): vs$(VSVER)\$(CFG)\$(PLAT)\atkmm $(atkmm_OBJS)
	link /DLL $(LDFLAGS_NOLTCG) $(ATKMM_DEP_LIBS) /implib:$(ATKMM_LIB) -out:$@ @<<
$(atkmm_OBJS)
<<
	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;2

# Rules for linking Executables
# Format is as follows (the mt command is needed for MSVC 2005/2008 builds):
# $(dll_name_with_path): $(dependent_libs_files_objects_and_items)
#	link [$(linker_flags)] [$(dependent_libs)] -out:$@ @<<
# $(dependent_objects)
# <<
# 	@-if exist $@.manifest mt /manifest $@.manifest /outputresource:$@;1

clean:
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.dll
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.ilk
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.exp
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\*.lib
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\*.res
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\*.pdb
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\*.obj
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\private\*.h
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\*.h
	@-del /f /q vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\*.cc
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\private
	@-rd vs$(VSVER)\$(CFG)\$(PLAT)\atkmm

.SUFFIXES: .cc .h .ccg .hg .obj
