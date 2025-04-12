/* Copyright (c) 2010  Openismus GmbH  <http://www.openismus.com/>
 *
 * This file is part of atkmm.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, see <https://www.gnu.org/licenses/>.
 */

#ifdef HAVE_CONFIG_H
# include <build/config.h>
#endif
// We always need to generate the .defs for all types because the code
// using deprecated API is generated unconditionally and only disabled
// at compile time.
#undef ATK_DISABLE_DEPRECATED

#include <glibmm_generate_extra_defs/generate_extra_defs.h>
#include <atk/atk.h>
#include <iostream>

int main(int, char**)
{
  // g_type_init() is deprecated as of glib-2.36.
  // g_type_init();

  void *const g_class_atk_no_op_object = g_type_class_ref(ATK_TYPE_NO_OP_OBJECT);

G_GNUC_BEGIN_IGNORE_DEPRECATIONS

  std::cout << get_defs(ATK_TYPE_OBJECT)
            << get_defs(ATK_TYPE_COMPONENT)
            << get_defs(ATK_TYPE_ACTION)
            << get_defs(ATK_TYPE_EDITABLE_TEXT)
            << get_defs(ATK_TYPE_HYPERLINK)
            << get_defs(ATK_TYPE_HYPERLINK_IMPL)
            << get_defs(ATK_TYPE_HYPERTEXT)
            << get_defs(ATK_TYPE_IMAGE)
            << get_defs(ATK_TYPE_MISC)
            << get_defs(ATK_TYPE_PLUG)
            << get_defs(ATK_TYPE_SELECTION)
            << get_defs(ATK_TYPE_SOCKET)
            << get_defs(ATK_TYPE_TABLE)
            << get_defs(ATK_TYPE_TEXT)
            << get_defs(ATK_TYPE_VALUE)
            << get_defs(ATK_TYPE_WINDOW)
            << get_defs(ATK_TYPE_REGISTRY)
            << get_defs(ATK_TYPE_RELATION)
            << get_defs(ATK_TYPE_RELATION_SET)
            << get_defs(ATK_TYPE_STATE_SET)
            ;

G_GNUC_END_IGNORE_DEPRECATIONS

  g_type_class_unref(g_class_atk_no_op_object);
  return 0;
}
