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
