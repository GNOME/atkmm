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
{$(OUTDIR)\atkmm\}.cc{$(OUTDIR)\atkmm\}.obj::
	$(CXX) $(CFLAGS) $(ATKMM_CFLAGS) $(ATKMM_INCLUDES) /Fo$(OUTDIR)\atkmm\ /Fd$(OUTDIR)\atkmm\ /c @<<
$<
<<

{..\untracked\atk\atkmm\}.cc{$(OUTDIR)\atkmm\}.obj::
	$(CXX) $(CFLAGS) $(ATKMM_CFLAGS) $(ATKMM_INCLUDES) /Fo$(OUTDIR)\atkmm\ /Fd$(OUTDIR)\atkmm\ /c @<<
$<
<<

{..\atk\atkmm\}.cc{$(OUTDIR)\atkmm\}.obj::
	$(CXX) $(CFLAGS) $(ATKMM_CFLAGS) $(ATKMM_INCLUDES) /Fo$(OUTDIR)\atkmm\ /Fd$(OUTDIR)\atkmm\ /c @<<
$<
<<

{..\atk\src\}.ccg{$(OUTDIR)\atkmm\}.obj:
	@if not exist $(@D)\private\ $(MAKE) /f Makefile.vc CFG=$(CFG) $(@D)\private
	@if not exist atkmm\atkmmconfig.h $(MAKE) /f Makefile.vc CFG=$(CFG) prep-git-build
	@if "$(UNIX_TOOLS_BINDIR_CHECKED)" == "" echo Warning: m4 is not in %PATH% or specified M4 or UNIX_TOOLS_BINDIR is not valid. Builds may fail!
	@set PATH=$(PATH);$(UNIX_TOOLS_BINDIR_CHECKED)
	@for %%s in ($(<D)\*.ccg) do @if not exist ..\atk\atkmm\%%~ns.cc if not exist $(@D)\%%~ns.cc $(PERL) -- $(GMMPROC_DIR)/gmmproc -I ../codegen/m4 --defs $(<D:\=/) %%~ns $(<D:\=/) $(@D)
	@if exist $(@D)\$(<B).cc $(CXX) $(CFLAGS) $(ATKMM_CFLAGS) $(ATKMM_INCLUDES) /Fo$(@D)\ /Fd$(@D)\ /c $(@D)\$(<B).cc
	@if exist ..\untracked\atk\atkmm\$(<B).cc $(CXX) $(CFLAGS) $(ATKMM_CFLAGS) $(ATKMM_INCLUDES) /Fo$(@D)\ /Fd$(@D)\ /c ..\untracked\atk\atkmm\$(<B).cc
	@if exist ..\atk\atkmm\$(<B).cc $(CXX) $(CFLAGS) $(ATKMM_CFLAGS) $(ATKMM_INCLUDES) /Fo$(@D)\ /Fd$(@D)\ /c ..\atk\atkmm\$(<B).cc

{.\atkmm\}.rc{$(OUTDIR)\atkmm\}.res:
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
$(ATKMM_DLL): $(OUTDIR)\atkmm $(atkmm_OBJS)
	link /DLL $(LDFLAGS) $(DEP_LDFLAGS) /implib:$(ATKMM_LIB) -out:$@ @<<
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
	@-del /f /q $(OUTDIR)\*.dll
	@-del /f /q $(OUTDIR)\*.pdb
	@-del /f /q $(OUTDIR)\*.ilk
	@-del /f /q $(OUTDIR)\*.exp
	@-del /f /q $(OUTDIR)\*.lib
	@-del /f /q $(OUTDIR)\atkmm\*.res
	@-del /f /q $(OUTDIR)\atkmm\*.pdb
	@-del /f /q $(OUTDIR)\atkmm\*.obj
	@-del /f /q $(OUTDIR)\atkmm\private\*.h
	@-del /f /q $(OUTDIR)\atkmm\*.h
	@-del /f /q $(OUTDIR)\atkmm\*.cc
	@-rd $(OUTDIR)\atkmm\private
	@-rd $(OUTDIR)\atkmm

.SUFFIXES: .cc .h .ccg .hg .obj
