Building atkmm on Win32
=

Currently, both the mingw (native win32) gcc compiler and MS Visual
Studio 2013 and later are supported. atkmm can be built with
mingw32-gcc using the gnu autotools (automake, autoconf, libtool) or
Meson.
As explicitly stated in the gtk+ for win32 distribution
(http://www.gimp.org/win32/), the gcc compiler provided by the cygwin
distribution should not be used to build atk/atkmm libraries and/or
applications (see the README.win32 that comes with the gtk+ DLLs).
This MIGHT cause conflicts between the cygwin and msvcrt runtime
environments.

### Mingw

The mingw distribution which has been tested with this release is the
following :

* MinGW-4.1 as the base distribution.

First, make sure that you have working distribution of the native port
of both libsigc++-2.x and atk on win32 (see
http://www.gimp.org/win32). If you can't compile a simple atk example
using gcc and `pkg-config --cflags --libs`, you should not even think
about trying to compile atkmm, let alone using precompiled libatkmm
DLLs to port your atkmm application !

#### MinGW builds using autotools

The bare mingw distribution does not provide the necessary tools (`sh`, `perl`, 
`m4`, `autoconf`, `automake`, ...) to run the provided configure script "as is". One
(currently non supported) solution is to use mingw in conjunction with msys,
which is readily available on the mingw website (http://www.mingw.org/).

The preferred method is to combine the cygwin distribution (for the unix tools
that were mentioned above) with mingw by making sure that the mingw
tools (`gcc`, `ld`, `dlltool`, ...) are called first.

The configure script can then be called using (as an example) the
following options

```
./configure --prefix=/target --build=i386-pc-mingw32 --disable-static

make
make check
make install
```

#### Meson with MinGW
The standard Meson build instructions for *NIX should work, although it
is untested at the time of writing.  Please see `README.md` for more details.

### MS Visual Studio 2013 or later

Note that it is generally not considered safe to link atkmm built with
Visual Studio 2013 with items that are built with Visual Studio 2015 and
later, and packages depending on atkmm can require Visual Studio 2015 or
later due to the more comprehensive `C++11` support in the later Visual Studio
versions.

#### Building using NMake
In a Visual Studio command prompt, navigate to the `MSVC_NMake` directory.
Run `nmake /f Makefile.vc CFG=[release|debug]` to build the atkmm DLL.
If a prefix other than `$(srcroot)\..\vs$(VSVER)\$(Platform)` is desired,
pass in `PREFIX=$(your_prefix)` in the NMake command line.

If using C++ dependencies that are built with Meson, specify `USE_MESON_LIBS=1`
in your NMake command line.

The following list lists the `$(VSVER)` and the `vc1xx` in the NMake-built DLL
and .lib that corresponds to the Visual Studio version used
(Visual Studio versions at or before 2012 are not supported):
  * 2013: `12`, `atkmm-vc120-1_6.[dll|pdb|lib]`
  * 2015: `14`, `atkmm-vc140-1_6.[dll|pdb|lib]`
  * 2017: `15`, `atkmm-vc141-1_6.[dll|pdb|lib]`
  * 2019: `16`, `atkmm-vc142-1_6.[dll|pdb|lib]`
  * 2022: `17`: `atkmm-vc143-1_6.[dll|pdb|lib]`

For Meson, the DLL/PDB filenames and .lib filenames will be like:
  * 2013: `atkmm-vc120-1.6-1.[dll|pdb]`, `atkmm-vc140-1.6.lib`
  * 2015: `atkmm-vc140-1.6-1.[dll|pdb]`, `atkmm-vc140-1.6.lib`
  * 2017: `atkmm-vc141-1.6-1.[dll|pdb]`, `atkmm-vc141-1.6.lib`
  * 2019: `atkmm-vc142-1.6-1.[dll|pdb]`, `atkmm-vc142-1.6.lib`
  * 2022: `atkmm-vc143-1.6-1.[dll|pdb]`, `atkmm-vc143-1.6.lib`

Notice that this is no longer always the `vc$(VSVER)` that was used before, to be consistent with other common C++ libraries such as Boost.
Earlier gtkmm versions may still use the former `vc140` naming scheme, so for 
situations like where rebuilding code using atkmm became
inconvenient, a `USE_COMPAT_LIBS=1` NMake option is provided to use the older naming scheme.
(or use `-Dmsvc14x-parallel-installable=false` in the Meson configure command line
to avoid having the toolset version in the final DLL and .lib filenames);
again, this is only recommended if it is inconvenient to re-build the
dependent code.

For the NMake builds, the following targets are supported:

  * `all` (or no target specified): Build the atkmm DLL and .lib
  * `install`: Copy the built atkmm DLL, .lib and headers to appropriate
locations under `$(PREFIX)`.
  * `clean`: Remove all the built files.  This includes the generated sources
if building from a GIT checkout, as noted below.

The NMake Makefiles now support building the atkmm libraries directly from a GIT 
checkout with a few manual steps required, namely:

  * Ensure that you have a copy of Cygwin or MSYS/MSYS64 installed, including
`m4.exe` and `sh.exe`.  You should also have a PERL for Windows installation
as well, and your `%PATH%` should contain the paths to your PERL interpreter
and the bin\ directory of your Cygwin or MSYS/MSYS64 installation, it is 
recommended that these paths are towards the end of your `%PATH%`. You need to 
install the `XML::Parser` PERL module as well for your PERL installation, which 
requires libexpat.

  * You may wish to pass in the directory where gmmproc and generate_wrap_init.pl
from glibmm is found, if they are not in `$(PREFIX)\share\glibmm-2.4\proc`, using 
`GMMPROC_DIR=...` in the NMake commandline.

  * Make a new copy of the entire source tree to some location, where the build
is to be done; then in `$(srcroot)\MSVC_NMake` run `nmake /f Makefile.vc CFG=[release|debug]`,
which will first copy and generate the following files with the proper info (this step will also
be run if the following files are not present in the unpacked source tarball):
```
$(srcroot)\MSVC_NMake\atkmm\atkmmconfig.h
$(srcroot)\MSVC_NMake\atkmm\atkmm.rc
```

For `atkmmconfig.h`, it is recommended to keep `ATKMM_DISABLE_DEPRECATED` and
`ATKMM_STATIC_LIB` undefined unless you know what you are doing.  Note that it is
generally not supported to build static builds of atkmm using Visual Studio.

Note that to generate any of the above 2 files with NMake, a PERL installation is 
also required.

#### Building Using Meson

For building with Meson, please see `README.md` for further instructions. Please 
note that using `-Ddefault_library=[static|both]` for Visual Studio builds is not 
supported and is thus not allowed.

You will need to have a working copy of glibmm-2.4 and atk's pkg-config files, 
which point to the corresponding locations of its headers and .lib's and the 
headers and .lib's of all of its dependencies. You will need to set `%LIB%` to 
include the location where `glibmm_generate_extra_defs-vc14[x]-2.4.lib` from glibmm
is, if not already in there, preferably to the start of your `%LIB%`. glibmm-2.4 
refers to the C++11 branches of glibmm, where the latest version is glibmm-2.66.x.

When building with Meson, if building from a GIT checkout or if building with 
`maintainer-mode` enabled, you will also need a PERL interpreter and the `m4.exe` 
and `sh.exe` from Cygwin or MSYS/MSYS64, and you will need to also install Doxygen,
LLVM (likely needed by Doxygen) and GraphViz unless you pass in 
`-Dbuild-documentation=false` in your Meson configure command line.  You will still
need to have `mm-common` installed with its `bin` directory in your `%PATH%`, along
with the `gmmproc` items from glibmm, which will be found with `pkg-config`.

Note also that before building, if using Visual Studio 2013, you will
need to ensure that 'warnings' is not configured to `fatal` (the
default), as the C++11 support in Visual Studio 2013 is not complete
enough to avoid compiler warnings.  Visual Studio 2015 and later
should be able to build without warnings. The Ninja build tool is
also required if not using `--backend=[vs2015|vs2017|vs2019|vs2022]` in the Meson
command line, as noted towards the end of this section.

Note that `debug` builds should only be used against dependencies that are built
as debug builds, and `release`and `debugoptimized` should be only used against
dependencies that are built as `release` or `debugoptimized`.  On Visual Studio
builds in Meson, `debugoptimized` is roughly equivilant to a Release build with
.PDB files enabled, perhaps with some debugging features that are specific to the
respective packages.

### atkmm methods and signals not available on win32

All atkmm methods and signals are available on win32.

