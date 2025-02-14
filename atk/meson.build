# atk

# Input: install_prefix, install_datadir, install_includedir,
#        atkmm_pcname, atkmm_api_version, atkmm_requires,
#        install_pkgconfigdir, install_libdir, build_deprecated_api,
#        atkmm_major_version, atkmm_minor_version, atkmm_micro_version,
#        msvc14x_toolset_ver
# Output: pkg_conf_data, install_includeconfigdir, atkmmconfig_h_meson

pkg_conf_data = configuration_data()
pkg_conf_data.set('prefix', install_prefix)
pkg_conf_data.set('exec_prefix', '${prefix}')
pkg_conf_data.set('libdir', '${exec_prefix}' / install_libdir)
pkg_conf_data.set('datarootdir', '${prefix}' / install_datadir)
pkg_conf_data.set('datadir', '${datarootdir}')
pkg_conf_data.set('includedir', '${prefix}' / install_includedir)
pkg_conf_data.set('srcdir', meson.current_source_dir())
pkg_conf_data.set('PACKAGE_TARNAME', meson.project_name())
pkg_conf_data.set('PACKAGE_VERSION', meson.project_version())
pkg_conf_data.set('ATKMM_MODULE_NAME', atkmm_pcname)
pkg_conf_data.set('ATKMM_API_VERSION', atkmm_api_version)
pkg_conf_data.set('ATKMM_MODULES', atkmm_requires)
if not build_deprecated_api
  pkg_conf_data.set('ATKMM_DISABLE_DEPRECATED', 1)
endif
pkg_conf_data.set('ATKMM_MAJOR_VERSION', atkmm_major_version)
pkg_conf_data.set('ATKMM_MINOR_VERSION', atkmm_minor_version)
pkg_conf_data.set('ATKMM_MICRO_VERSION', atkmm_micro_version)
pkg_conf_data.set('MSVC_TOOLSET_VER', msvc14x_toolset_ver)

library_build_type = get_option('default_library')

if cpp_compiler.get_argument_syntax() == 'msvc'
  if library_build_type == 'static' or library_build_type == 'both'
    error('Static builds are not supported by MSVC-style builds')
  endif
endif

if library_build_type == 'static'
  pkg_conf_data.set('ATKMM_STATIC_LIB', 1)
endif

configure_file(
  input: 'atkmm.pc.in',
  output: atkmm_pcname + '.pc',
  configuration: pkg_conf_data,
  install: true,
  install_dir: install_pkgconfigdir,
  install_tag: 'devel',
)

configure_file(
  input: 'atkmm-uninstalled.pc.in',
  output: atkmm_pcname + '-uninstalled.pc',
  configuration: pkg_conf_data,
)

atkmmconfig_h_meson = files('atkmmconfig.h.meson')
install_includeconfigdir = install_libdir / atkmm_pcname / 'include'
configure_file(
  input: atkmmconfig_h_meson,
  output: 'atkmmconfig.h',
  configuration: pkg_conf_data,
  install: true,
  install_dir: install_includeconfigdir,
  install_tag: 'devel',
)
