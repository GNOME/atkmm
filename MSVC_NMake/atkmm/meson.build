# MSVC_NMake/atkmm

# Input: pkg_conf_data, atkmmconfig_h_meson
# Output: atkmm_rc

atkmm_rc = configure_file(
  input: 'atkmm.rc.in',
  output: '@BASENAME@',
  configuration: pkg_conf_data,
)

# Make a copy of the generated configuration header in the MSVC project directory.
configure_file(
  input: atkmmconfig_h_meson,
  output: 'atkmmconfig.h',
  configuration: pkg_conf_data,
)
