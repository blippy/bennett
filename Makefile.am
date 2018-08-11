bin_PROGRAMS = vam vas vc

YFLAGS = -d
BUILT_SOURCES = parser.c scanner.c parser.h vas.c vas.h
CLEANFILES = $(BUILT_SOURCES)

vc_LDADD = -lfl
vc_SOURCES = cg.c cg-sys.cc main.c parser.y scanner.l

vam_SOURCES = vam.c

vas_SOURCES = vas.y
