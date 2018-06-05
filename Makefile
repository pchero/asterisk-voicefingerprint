#Makefile
# Created on: Nov 9, 2015
#     Author: pchero


#### Compiler and tool definitions shared by all build targets #####
CC = gcc
UNAME := $(shell uname)
BASICOPTS = -Wall -g -pthread -pipe -g3 -O6 -fPIC -DAST_MODULE=\"app_voicefingerprint\" -DAST_MODULE_SELF_SYM=__app_voicefingerprint
CFLAGS = $(BASICOPTS)
PKGCONFIG="pkg-config"
OSLDLIBS=

# Define the target directories.
TARGETDIR=build

ifeq ($(UNAME), Linux)
	SHAREDLIB_FLAGS = -shared -Xlinker -x -Wl,--hash-style=gnu -Wl,--as-needed -rdynamic
endif

ifeq ($(UNAME), Darwin)
	PKGCONFIG=$(shell if [ "x$(HOMEBREW_PREFIX)" == "x" ];then echo "/usr/local/bin/pkg-config"; else echo "$(HOMEBREW_PREFIX)/bin/pkg-config"; fi)

	# Link or archive
	SHAREDLIB_FLAGS = -bundle -Xlinker -macosx_version_min -Xlinker 10.4 -Xlinker -undefined -Xlinker dynamic_lookup -force_flat_namespace
	OSLDLIBS=/usr/lib/bundle1.o
endif

all: $(TARGETDIR)/app_voicefingerprint.so

## Target: app_voicefingerprint.so
CFLAGS += \
	-I/usr/include/ \
	-I/usr/local/include/
	
LDLIBS = $(OSLDLIBS) -lpython2.7

OBJS =  \
	$(TARGETDIR)/app_voicefingerprint.o 
	
	

# WARNING: do not run this directly, it should be run by the master Makefile 
$(TARGETDIR)/app_voicefingerprint.so: $(TARGETDIR) $(OBJS)
	$(LINK.c) $(CFLAGS.so) $(CFLAGS.so) -o $@ $(OBJS) $(SHAREDLIB_FLAGS) $(LDLIBS)

# Compile source files into .o files
$(TARGETDIR)/app_voicefingerprint.o: $(TARGETDIR) src/app_voicefingerprint.c 
	$(COMPILE.c) $(CFLAGS.so) -o $@ src/app_voicefingerprint.c

#### Clean target deletes all generated files ####
clean:
	rm -f \
		$(TARGETDIR)/res_outbound.so \
		$(TARGETDIR)/*.o
	rm -f -r $(TARGETDIR)
	
install:
	mv $(TARGETDIR)/app_voicefingerprint.so /usr/lib/asterisk/modules/


# Create the target directory (if needed)
$(TARGETDIR):
	mkdir -p $(TARGETDIR)


# Enable dependency checking
#.KEEP_STATE:
#.KEEP_STATE_FILE:.make.state.GNU-amd64-Linux
