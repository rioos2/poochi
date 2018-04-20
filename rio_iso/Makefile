#!/usr/bin/make -f
#
# Rio/OS Installer system makefile.
# Copyright 2017-2018 by the Rio Advancement Inc
#

SHELL = /bin/sh

#### Start of system configuration section. ####

# Temporary BUILDDIR
BUILDDIR = ./build
USB_IMAGEDIR = $(BUILDDIR)/usb_image
MOUNT_ISODIR = ./mnt
MEGAM = $(BUILDDIR)/megam.iso
RIOOS = $(BUILDDIR)/rioos.iso
BASE_AVENTURA_URL = "http://releases.ubuntu.com/16.04.4/ubuntu-16.04.4-server-amd64.iso"
version := $(shell cat ../VERSION)
VERSION_FILE="./rioos/sh/tools/VERSION"

# By default, we just advertise what we can do.
.PHONY: all
all: list


# List all targets useful for direct invocation.
.PHONY: list
list:
	@echo "Useful targets:"
	@echo
	@echo "list"
	@echo "clean"
	@echo "aventura"
	@echo

# Clean all targets.
.PHONY: clean
clean:
	rm -rf $(BUILDDIR)

# all_build is provided automagically, but for manual invocation
# we provide a generic build rule.
.PHONY: aventura
aventura: wget_base_aventura tree_iso burn_usb
#qemu_test
	if [ -e $(RIOOS) ]; then \
		echo "--> Successfully created aventura_rioos 64bit distro"; \
	else \
		echo "Failure : Can't create aventura_rioos distro." ;  exit 2; \
	fi

# all_build is provided automagically, but for manual invocation
# we provide a generic build rule.
.PHONY: wget_base_aventura
wget_base_aventura:
	if [  -e $(MEGAM) ]; then \
		echo "Found base aventura 64 bit distro"; \
	else \
		mkdir -p $(BUILDDIR); \
		if [ -e $(VERSION_FILE) ]; then \
			echo "Version already updated.."; \
		else \
			echo $(version) >> $(VERSION_FILE); \
		fi; \
		echo "Downloading base aventura 64 bit"; \
		wget $(BASE_AVENTURA_URL) -O $(MEGAM); \
	fi

.PHONY:  tree_iso
tree_iso:
	if [ -e $(MEGAM) ]; then \
		mkdir $(MOUNT_ISODIR); \
		sudo mount -o loop $(MEGAM) $(MOUNT_ISODIR); \
	else \
	  echo "Base Aventura ISO not found.";  exit 1; \
	fi;\
	sudo cp -fr $(MOUNT_ISODIR) $(USB_IMAGEDIR); \
	sudo umount $(MOUNT_ISODIR);

.PHONY: burn_usb
burn_usb:
#Rio/OS logo configuration updates
	sudo cp ./usb/preseed.seed $(USB_IMAGEDIR)/preseed
	sudo cp ./usb/preseed1.seed $(USB_IMAGEDIR)/preseed
	sudo cp ./usb/preseed2.seed $(USB_IMAGEDIR)/preseed

	sudo cp ./usb/txt.cfg $(USB_IMAGEDIR)/isolinux
	sudo cp ./usb/grub.cfg $(USB_IMAGEDIR)/boot/grub
	sudo cp ./aventura/image/splash.png $(USB_IMAGEDIR)/isolinux/splash.png
	sudo sed -i '/gfxboot bootlogo/d' $(USB_IMAGEDIR)/isolinux/isolinux.cfg

# Copy Rio/OS service and shellscript into iso
	sudo cp ./usb/issue $(USB_IMAGEDIR)
	sudo cp ./usb/legal $(USB_IMAGEDIR)
	sudo cp ./usb/00-header $(USB_IMAGEDIR)
	sudo cp ./usb/10-help-text $(USB_IMAGEDIR)
	sudo cp ./usb/lsb-release $(USB_IMAGEDIR)
	sudo cp ./usb/os-release $(USB_IMAGEDIR)
	sudo cp ./usb/ca.crt $(USB_IMAGEDIR)
	sudo cp -r ./rioos $(USB_IMAGEDIR)

	sudo cp ./usb/rioos.service $(USB_IMAGEDIR)

# iso creation
	xorriso -as mkisofs -r -J -b isolinux/isolinux.bin -c boot.cat \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		-eltorito-alt-boot \
		--efi-boot boot/grub/efi.img -no-emul-boot \
		-o $(RIOOS) $(USB_IMAGEDIR); \
	./geniso_hybrid_plus_firmware_partition $(RIOOS);
	# while [ -z "$$CONTINUE" ]; do \
  #   read -r -p "--> Burn the iso in usb[/dev/sda]. Have you plugged it in ?   [y/N] " CONTINUE; \
	# done ; \
	# if [ $$CONTINUE = "y" ] || [ $$CONTINUE = "Y" ]; then \
	#   sudo dd if=$(RIOOS) of=/dev/sda; \
	# fi;

.PHONY:  qemu_test
qemu_test:
	qemu-system-x86_64  -cdrom $(RIOOS)
