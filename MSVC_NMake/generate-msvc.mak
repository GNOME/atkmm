# NMake Makefile portion for code generation and
# intermediate build directory creation
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.

# Create the build directories
vs$(VSVER)\$(CFG)\$(PLAT)\gendef	\
vs$(VSVER)\$(CFG)\$(PLAT)\atkmm:
	@-mkdir $@

# Generate .def files
vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\atkmm.def: $(GENDEF) vs$(VSVER)\$(CFG)\$(PLAT)\atkmm $(atkmm_OBJS)
	vs$(VSVER)\$(CFG)\$(PLAT)\gendef.exe $@ $(ATKMM_LIBNAME) vs$(VSVER)\$(CFG)\$(PLAT)\atkmm\*.obj
