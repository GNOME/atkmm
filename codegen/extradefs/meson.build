# codegen/extradefs

# Input: cpp_compiler, atkmm_build_dep, install_libdir, atkmm_pcname,
#        msvc14x_toolset_ver, glibmm_dep
# Output: m4_files, install_m4dir

glibmm_generate_extra_defs_dep = cpp_compiler.find_library(
  'glibmm_generate_extra_defs@0@-2.68'.format(msvc14x_toolset_ver),
  required: glibmm_dep.type_name() != 'internal',
)
if not glibmm_generate_extra_defs_dep.found()
  glibmm_generate_extra_defs_dep = dependency(
    '', fallback: ['glibmm-2.68', 'glibmm_generate_extra_defs_dep'],
  )
endif

executable('generate_extra_defs', 'generate_extra_defs_atk.cc',
  dependencies: [atkmm_build_dep, glibmm_generate_extra_defs_dep],
  implicit_include_directories: false,
  install: false,
)

# Install m4 files for reuse by other *mm projects, when building from git.
m4_basefiles = [
  'convert.m4',
  'convert_atk.m4',
]
m4_files = []
foreach file : m4_basefiles
  m4_files += '..' / 'm4' / file
endforeach
m4_files = files(m4_files)
install_m4dir = install_libdir / atkmm_pcname / 'proc' / 'm4'
install_data(m4_files,
  install_dir: install_m4dir,
  install_tag: 'bin-devel',
)
