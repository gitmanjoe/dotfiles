UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
  ASMC = nasm
  QEMU = qemu-system-x86_64
endif
# No need for Windows support

BOOTLOADER = bootloader.s
BUILDDIR = bin
OSIMAGE = $(BUILDDIR)/J-BDauws.bin

ASMFLAGS = -f bin
all: $(OSIMAGE)

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

$(OSIMAGE): BOOTLOADER
  $(ASMC) $(ASMFLAGS) $(BOOTLOADER) -o $(OSIMAGE)

clean:
	rm -rf $(BUILDDIR)

run: $(OSIMAGE)
  $(QEMU) -drive file=$(OS_IMAGE),format=raw
