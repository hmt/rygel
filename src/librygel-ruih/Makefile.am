include ../../common.am
include $(srcdir)/filelist.am

librygel_ruih_includedir=$(includedir)/rygel-2.6
librygel_ruih_include_HEADERS = rygel-ruih.h

lib_LTLIBRARIES = librygel-ruih-2.0.la

LIBRYGEL_RUIH_VERSION=1:0:0

librygel_ruih_2_0_la_SOURCES = \
        $(LIBRYGEL_RUIH_VAPI_SOURCE_FILES) \
        $(LIBRYGEL_RUIH_NONVAPI_SOURCE_FILES)

librygel_ruih_2_0_la_VALAFLAGS = \
        -H rygel-ruih.h --library=rygel-ruih-2.0 \
        $(LIBRYGEL_RUIH_DEPS_VALAFLAGS) \
        $(RYGEL_COMMON_LIBRYGEL_CORE_VALAFLAGS) \
        $(RYGEL_COMMON_VALAFLAGS)

librygel_ruih_2_0_la_CFLAGS = \
        $(LIBRYGEL_SERVER_DEPS_CFLAGS) \
        $(RYGEL_COMMON_LIBRYGEL_CORE_CFLAGS) \
        -DENGINE_DIR='"$(enginedir)"' \
        -DG_LOG_DOMAIN=\"Rygel\"
librygel_ruih_2_0_la_LIBADD = \
        $(LIBRYGEL_RUIH_DEPS_LIBS) \
        $(RYGEL_COMMON_LIBRYGEL_CORE_LIBS)

librygel_ruih_2_0_la_LDFLAGS = \
        $(RYGEL_DATA_DIR_DEFINES) \
        -version-info $(LIBRYGEL_RUIH_VERSION)

vapidir = $(VAPIDIR)
vapi_DATA = rygel-ruih-2.0.vapi rygel-ruih-2.0.deps

rygel-ruih.h rygel-ruih-2.0.vapi: librygel_ruih_2_0_la_vala.stamp

EXTRA_DIST = rygel-ruih.h rygel-ruih-2.0.vapi rygel-ruih-2.0.deps
