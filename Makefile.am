SUBDIRS = src data tests po doc examples

pkgconfig_DATA= rygel-core-2.6.pc rygel-renderer-2.6.pc rygel-server-2.6.pc
pkgconfigdir = $(libdir)/pkgconfig

if HAVE_GSTREAMER
pkgconfig_DATA += rygel-renderer-gst-2.6.pc
endif

EXTRA_DIST = rygel-core-2.6.pc.in rygel-renderer-2.6.pc.in \
             rygel-server-2.6.pc.in .version \
             build-aux/git-version-gen

DISTCHECK_CONFIGURE_FLAGS =

# Extra clean files so that maintainer-clean removes *everything*
MAINTAINERCLEANFILES = aclocal.m4 compile config.guess config.sub configure depcomp install-sh ltmain.sh Makefile.in missing config.h.in

ACLOCAL_AMFLAGS = -I m4

# see build-aux/git-version-get for details
BUILT_SOURCES = $(top_srcdir)/.version
$(top_srcdir)/.version:
	echo $(VERSION) > $@-t && mv $@-t $@
dist-hook:
	echo $(VERSION) > $(distdir)/.tarball-version
	@if test -d "$(srcdir)/.git"; \
		then \
				echo Creating ChangeLog && \
				( cd "$(top_srcdir)" && \
				  echo '# Generated by Makefile. Do not edit.'; echo; \
				  "$(top_srcdir)"/build-aux/missing --run git log --stat ) > ChangeLog.tmp \
				&& mv -f ChangeLog.tmp $(distdir)/ChangeLog \
				|| ( rm -f ChangeLog.tmp ; \
					 echo Failed to generate ChangeLog >&2 ); \
		else \
				echo A git clone is required to generate a ChangeLog >&2; \
		fi

vala-clean:
	rm -f `find . -name "*.stamp"`
