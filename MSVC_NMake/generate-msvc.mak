# NMake Makefile portion for code generation and
# intermediate build directory creation
# Items in here should not need to be edited unless
# one is maintaining the NMake build files.

# Create the build directories
$(CFG)\$(PLAT)\gendef	\
$(CFG)\$(PLAT)\atkmm:
	@-mkdir $@

# Generate .def files
$(CFG)\$(PLAT)\atkmm\atkmm.def: $(GENDEF) $(CFG)\$(PLAT)\atkmm $(atkmm_OBJS)
	$(CFG)\$(PLAT)\gendef.exe $@ $(ATKMM_LIBNAME) $(CFG)\$(PLAT)\atkmm\*.obj
