## Copyright (c) 2010  Openismus GmbH  <http://www.openismus.com/>
##
## This file is part of atkmm.
##
## atkmm is free software: you can redistribute it and/or modify it
## under the terms of the GNU Lesser General Public License as published
## by the Free Software Foundation, either version 2.1 of the License,
## or (at your option) any later version.
##
## atkmm is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
## See the GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

binding_name    = atkmm
wrap_init_flags = --namespace=Atk --parent_dir=atkmm

include $(srcdir)/filelist.am
include $(top_srcdir)/codegen/m4/filelist.am

files_defs = $(atkmm_files_defs)
files_ccg  = $(atkmm_files_ccg)
files_hg   = $(atkmm_files_hg)

include $(top_srcdir)/build/generate-binding.am
