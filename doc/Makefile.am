## Copyright (c) 2010  Openismus GmbH <http://www.openismus.com/>
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

include $(top_srcdir)/atk/src/filelist.am
include $(top_srcdir)/atk/atkmm/filelist.gmake.am

atkmm_files_h = $(atkmm_files_built_h) $(filter-out wrap_init.h,$(atkmm_files_extra_h))

book_name = $(ATKMM_MODULE_NAME)
doc_input = $(top_srcdir)/atk/atkmm.h $(addprefix $(top_srcdir)/atk/atkmm/,$(atkmm_files_h))

include $(top_srcdir)/build/doc-reference.am
