# atk/atkmm

# Input: atkmm_build_dep, atkmm_pcname, maintainer_mode, project_source_root,
#        generate_binding_py, m4_files, atkmm_libversion, install_includedir,
#        python3, atkmm_rc, dummy_header_py, gmmproc_dir, build_shared_libs_directly,
#        msvc14x_toolset_ver
# Output: hg_ccg_basenames, extra_h_files, built_h_file_targets, built_files_root,
#         atkmm_dep

defs_basefiles = [
  'atk.defs',
  'atk_enums.defs',
  'atk_methods.defs',
  'atk_signals.defs',
  'atk_vfuncs.defs',
  'atk_docs.xml',
  'atk_docs_override.xml',
]

defs_files = []
foreach file : defs_basefiles
  defs_files += '..' / 'src' / file
endforeach

hg_ccg_basenames = [
  'action',
  'component',
  'document',
  'editabletext',
  'hyperlink',
  'hypertext',
  'image',
  'implementor',
  'noopobject',
  'object',
  'objectaccessible',
  'range',
  'relation',
  'relationset',
  'selection',
  'stateset',
  'streamablecontent',
  'table',
  'text',
  'value',
]

extra_cc_files = [
  'init.cc',
]

extra_h_files = [
  'init.h',
  'wrap_init.h',
]

install_headers('..' / 'atkmm.h', subdir: atkmm_pcname)
install_headers(extra_h_files, subdir: atkmm_pcname / 'atkmm')

untracked_atkmm = 'untracked' / 'atk' / 'atkmm'
src_untracked_atkmm = project_source_root / untracked_atkmm

atkmm_cpp_args = [ '-DATKMM_BUILD=1' ]

if is_msvc and not build_shared_libs_directly
  atkmm_cpp_args += '-DATKMM_USE_GENDEF'
endif

if maintainer_mode

  # Maintainer mode. Generate .h and .cc files from .hg and .ccg files in ../src.

  # doc/reference/meson.build needs these.
  built_files_root = project_build_root
  built_h_file_targets = []

  # Force meson+ninja to generate source files before anything is compiled.
  # Compilation must depend on these targets.
  built_cc_file_targets = []

  hg_files = []
  foreach file : hg_ccg_basenames
    hg_files += '..' / 'src' / file + '.hg'
  endforeach

  # Create wrap_init.cc in project_build_root/atk/atkmm.
  built_cc_file_targets += custom_target('wrap_init.cc',
    input: hg_files,
    output: 'wrap_init.cc',
    command: [
      python3, generate_binding_py, 'generate_wrap_init',
      gmmproc_dir,
      '@OUTPUT@',
      'Atk', # namespace
      '@INPUT@',
    ],
    build_by_default: maintainer_mode,
    install: false,
  )

  # Create .h/_p.h/.cc files from .hg/.ccg files in project_build_root/atk/atkmm.
  foreach file : hg_ccg_basenames
    hg_file = '..' / 'src' / file + '.hg'
    ccg_file = '..' / 'src' / file + '.ccg'
    built_file_target = custom_target(file + '.cc',
      input: [hg_file, ccg_file],
      output: [file + '.stamp', file + '.cc', file + '.h'],
      command: [
        python3, generate_binding_py, 'gmmproc',
        gmmproc_dir,
        '@OUTPUT0@',
        file,
        meson.current_source_dir() / '..' / 'src',
        project_source_root / 'codegen' / 'm4',
      ],
      depend_files: defs_files + m4_files,
      build_by_default: maintainer_mode,
      install: false,
    )
    built_cc_file_targets += built_file_target[1]
    built_h_file_targets += built_file_target[2]
  endforeach

  # Create dummy_header.h, depending on all generated headers.
  # It's created if it does not exist, but it's never updated.
  # It guarantees that all generated headers are built before atkmm_library
  # is built, at the same time avoiding unnecessary recompilations.
  # If built_h_file_targets would be listed as sources to atkmm_library,
  # all generated .cc files could be recompiled if one generated .h file has
  # been changed.
  built_dummy_h_file_target = custom_target('dummy_header.h',
    input: built_h_file_targets,
    output: 'dummy_header.h',
    command: [
      python3, dummy_header_py,
      '@OUTPUT@',
    ],
    build_by_default: maintainer_mode,
    install: false,
  )

  extra_include_dirs = ['..']

  atk_gen_sources = built_cc_file_targets

  built_h_cc_dir = meson.current_build_dir()

else # not maintainer_mode

  # Not maintainer mode. Compile built source code files in
  # project_source_root/untracked/atk/atkmm.

  # doc/reference/meson.build needs these.
  built_files_root = project_source_root / 'untracked'
  built_h_file_targets = []

  # Two cases:
  # 1. The source code comes from a tarball, where the built files
  #    are stored in project_source_root/untracked.
  #    There are no built files in the build tree.
  # 2. Files have been built in the build tree. Then maintainer_mode has
  #    been changed from true to false. Files that are missing or not up to date
  #    in project_source_root/untracked are copied from the build tree.

  # Try to copy built source code files to the source tree.
  run_command(
    python3, generate_binding_py, 'copy_built_files',
    meson.current_build_dir(),
    src_untracked_atkmm,
    hg_ccg_basenames,
  )

  built_cc_files = [ src_untracked_atkmm / 'wrap_init.cc' ]
  foreach file : hg_ccg_basenames
    built_cc_files += src_untracked_atkmm / file + '.cc'
  endforeach

  atk_gen_sources = built_cc_files
  built_dummy_h_file_target = []

  extra_include_dirs = [ '..', '..' / '..' / 'untracked' / 'atk' ]

  built_h_cc_dir = src_untracked_atkmm

endif

extra_atkmm_objects = []

# Build the .rc file for Windows builds and link to it
if host_machine.system() == 'windows'
  windows = import('windows')
  atkmm_res = windows.compile_resources(atkmm_rc)
  extra_atkmm_objects += atkmm_res
endif

atkmm_libname = meson.project_name() + msvc14x_toolset_ver + '-' + atkmm_api_version

if build_shared_libs_directly
  atkmm_library = library(atkmm_libname, extra_atkmm_objects,
    atk_gen_sources, built_dummy_h_file_target, extra_cc_files,
    include_directories: extra_include_dirs,
    cpp_args: atkmm_cpp_args,
    version: atkmm_libversion,
    dependencies: atkmm_build_dep,
    install: true,
  )
else
  # Building with headers generated from *.hg files with
  # gmmproc < 2.64.0 on Visual Studio: We need this so
  # that we can run gendef.exe to get the .def file
  # needed for obtaining the .lib file for the atkmm DLL
  atk_int_lib = static_library('atkmm-int',
    atk_gen_sources, built_dummy_h_file_target, extra_cc_files,
    include_directories: extra_include_dirs,
    cpp_args: atkmm_cpp_args,
    dependencies: atkmm_build_dep,
    install: false,
  )

  atkmm_def = custom_target('atkmm.def',
    output: 'atkmm.def',
    depends: atk_int_lib,
    command: [ gendef,
      '@OUTPUT@',
      '@0@-@1@.dll'.format(atkmm_libname, atkmm_libversion.split('.')[0]),
      atk_int_lib.full_path(),
    ],
    install: false,
  )
  atkmm_extra_link_args = ['/def:@0@'.format(atkmm_def.full_path())]

  atkmm_library = library(atkmm_libname, extra_atkmm_objects,
    objects: atk_int_lib.extract_all_objects(),
    version: atkmm_libversion,
    dependencies: atkmm_build_dep,
    link_depends: atkmm_def,
    link_args: atkmm_extra_link_args,
    install: true,
  )
endif

# Install built .h and _p.h files.
meson.add_install_script(
  python3.path(), generate_binding_py, 'install_built_h_files',
  built_h_cc_dir,
  install_includedir / atkmm_pcname / 'atkmm', # subdir below {prefix}
  hg_ccg_basenames
)

if not meson.is_subproject()
  # Distribute built files.
  # (add_dist_script() is not allowed in a subproject)
  meson.add_dist_script(
    python3.path(), generate_binding_py, 'dist_built_files',
    built_h_cc_dir,
    untracked_atkmm,
    hg_ccg_basenames,
  )
endif

# This is useful in the main project when atkmm is used as a subproject.
# It can also be used if there are example programs and test programs to build.
atkmm_dep = declare_dependency(
  sources: built_h_file_targets,
  link_with: atkmm_library,
  include_directories: extra_include_dirs,
  dependencies: atkmm_build_dep
)
