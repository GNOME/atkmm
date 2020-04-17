# MSVC_NMake/atkmm

# Input: pkg_conf_data, atkmmconfig_h
# Output: atkmm_rc

atkmm_rc = configure_file(
  input: 'atkmm.rc.in',
  output: '@BASENAME@',
  configuration: pkg_conf_data,
)

# Copy the generated configuration header into the MSVC project directory.
configure_file(
  input: atkmmconfig_h,
  output: 'atkmmconfig.h',
  copy: true,
)
