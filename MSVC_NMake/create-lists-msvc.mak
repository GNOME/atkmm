# Convert the source listing to object (.obj) listing in
# another NMake Makefile module, include it, and clean it up.
# This is a "fact-of-life" regarding NMake Makefiles...
# This file does not need to be changed unless one is maintaining the NMake Makefiles

# For those wanting to add things here:
# To add a list, do the following:
# # $(description_of_list)
# if [call create-lists.bat header $(makefile_snippet_file) $(variable_name)]
# endif
#
# if [call create-lists.bat file $(makefile_snippet_file) $(file_name)]
# endif
#
# if [call create-lists.bat footer $(makefile_snippet_file)]
# endif
# ... (repeat the if [call ...] lines in the above order if needed)
# !include $(makefile_snippet_file)
#
# (add the following after checking the entries in $(makefile_snippet_file) is correct)
# (the batch script appends to $(makefile_snippet_file), you will need to clear the file unless the following line is added)
#!if [del /f /q $(makefile_snippet_file)]
#!endif

# In order to obtain the .obj filename that is needed for NMake Makefiles to build DLLs/static LIBs or EXEs, do the following
# instead when doing 'if [call create-lists.bat file $(makefile_snippet_file) $(file_name)]'
# (repeat if there are multiple $(srcext)'s in $(source_list), ignore any headers):
# !if [for %c in ($(source_list)) do @if "%~xc" == ".$(srcext)" @call create-lists.bat file $(makefile_snippet_file) $(intdir)\%~nc.obj]
#
# $(intdir)\%~nc.obj needs to correspond to the rules added in build-rules-msvc.mak
# %~xc gives the file extension of a given file, %c in this case, so if %c is a.cc, %~xc means .cc
# %~nc gives the file name of a given file without extension, %c in this case, so if %c is a.cc, %~nc means a

NULL=

# Ensure we build the right generated sources for atkmm
atkmm_generated_private_headers = $(atkmm_files_used_hg:.hg=_p.h)
atkmm_files_extra_ph_int = $(atkmm_files_extra_ph:/=\)

# For atkmm

!if [call create-lists.bat header atkmm.mak atkmm_OBJS]
!endif

!if [for %c in ($(atkmm_files_built_cc)) do @if "%~xc" == ".cc" @call create-lists.bat file atkmm.mak vs^$(PDBVER)\^$(CFG)\^$(PLAT)\atkmm\%~nc.obj]
!endif

!if [for %c in ($(atkmm_files_extra_cc)) do @if "%~xc" == ".cc" @call create-lists.bat file atkmm.mak vs^$(PDBVER)\^$(CFG)\^$(PLAT)\atkmm\%~nc.obj]
!endif

!if [@call create-lists.bat file atkmm.mak vs^$(PDBVER)\^$(CFG)\^$(PLAT)\atkmm\atkmm.res]
!endif

!if [call create-lists.bat footer atkmm.mak]
!endif

!if [call create-lists.bat header atkmm.mak atkmm_real_hg]
!endif

!if [for %c in ($(atkmm_files_hg)) do @call create-lists.bat file atkmm.mak ..\atk\src\%c]
!endif

!if [call create-lists.bat footer atkmm.mak]
!endif

!if [for %f in (atkmm\action.h) do @if not exist ..\atk\%f if not exist ..\untracked\atk\%f if not exist vs$(PDBVER)\$(CFG)\$(PLAT)\%f (md vs$(PDBVER)\$(CFG)\$(PLAT)\atkmm\private) & ($(PERL) -- $(GMMPROC_DIR)/gmmproc -I ../tools/m4 --defs ../atk/src action ../atk/src vs$(PDBVER)/$(CFG)/$(PLAT)/atkmm)]
!endif

!if [for %d in (vs$(PDBVER)\$(CFG)\$(PLAT)\atkmm ..\atk\atkmm ..\untracked\atk\atkmm) do @if exist %d\action.h call get-gmmproc-ver %d\action.h>>atkmm.mak]
!endif

!include atkmm.mak

!if [del /f /q atkmm.mak]
!endif

!if "$(GMMPROC_VER)" >= "2.64.3"
ATKMM_INT_TARGET = vs$(PDBVER)\$(CFG)\$(PLAT)\atkmm
ATKMM_DEF_LDFLAG =
!else
ATKMM_INT_TARGET = vs$(PDBVER)\$(CFG)\$(PLAT)\atkmm\atkmm.def
ATKMM_DEF_LDFLAG = /def:$(ATKMM_INT_TARGET)
ATKMM_BASE_CFLAGS = $(ATKMM_BASE_CFLAGS) /DATKMM_USE_GENDEF
!endif
