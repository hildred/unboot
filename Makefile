
all: grub.cfg menu.ipxe grubtemp default.i386.cfg default.amd64.cfg
.PHONY:
.SECONDARY:


grub.cfg: buildmenu menufile grub.lib
	./buildmenu grub menufile > $@

menu.ipxe: buildmenu menufile ipxe.lib
	./buildmenu ipxe menufile > $@

default.cfg: buildmenu menufile pxelinux.lib
	./buildmenu pxelinux menufile > $@

grubtemp: /etc/grub.d/*
	sudo grub-mkconfig > $@

default.i386.cfg: default.cfg
	./expandvars arch=i386 $< > $@
	
default.amd64.cfg: default.cfg
	./expandvars arch=amd64 $< > $@

diff: all
	diff -q menu.ipxe boot|| vimdiff menu.ipxe boot
	diff -q grub.cfg ../tftpboot/grub2/grub.cfg||vimdiff grub.cfg ../tftpboot/grub2/grub.cfg
	diff -q grubtemp /boot/grub/grub.cfg ||EDITOR='vimdiff grubtemp' sudoedit /boot/grub/grub.cfg
	diff -q default.cfg menu.cfg ||vimdiff default.cfg menu.cfg

diffx: diff
	diff -q grub.cfg grubtemp||vimdiff grub.cfg grubtemp
