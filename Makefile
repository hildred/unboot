
all: grub.cfg menu.ipxe grubtemp default.i386.cfg default.amd64.cfg # grub.pxe grub32.efi grub64.efi
.PHONY:
.SECONDARY:

grub.pxe:
	grub-mkimage -O i386-pc-pxe -o grub.pxe -p '(pxe)/tftpboot/grub' pxecmd pxe bufio normal boot gfxterm video video_fb pci png echo multiboot bsd echo cpuid gzio minicmd vbe

grub32.efi:
	grub-mkimage -O i386-efi -o grub32.efi -p '(pxe)/tftpboot/grub32efi'

grub64.efi:
	grub-mkimage -O x86_64-efi -o grub64.efi -p '(pxe)/tftpboot/grub64efi'

grub.cfg: buildmenu menufile grub.lib
	./buildmenu grub menufile > $@

menu.ipxe: buildmenu menufile ipxe.lib
	./buildmenu ipxe menufile > $@

default.cfg: buildmenu menufile pxelinux.lib
	./buildmenu pxelinux menufile > $@

grubtemp: /etc/grub.d/*
	sudo grub-mkconfig > $@

default.i386.cfg: default.cfg Makefile
	./expandvars arch=i386 video=gtk dvideo='dvideo video=vesa:ywrap,mtrr vga=788' ddesktop=xfce ddebug=' ' dpreseed=' ' dmode='-- quiet' $< > $@
	
default.amd64.cfg: default.cfg Makefile
	./expandvars arch=amd64 video=gtk dvideo='dvideo video=vesa:ywrap,mtrr vga=788' ddesktop=xfce ddebug=' ' dpreseed=' ' dmode='-- quiet' $< > $@

#diff: all
#	diff -q menu.ipxe boot.hold|| vimdiff menu.ipxe boot.hold
#	diff -q default.cfg menu.cfg ||vimdiff default.cfg menu.cfg
diff: all
	diff -q menu.ipxe boot|| vimdiff menu.ipxe boot
	diff -q grub.cfg ../tftpboot/grub2/grub.cfg||vimdiff grub.cfg ../tftpboot/grub2/grub.cfg
	diff -q grubtemp /boot/grub/grub.cfg ||EDITOR='vimdiff grubtemp' sudoedit /boot/grub/grub.cfg
	diff -q default.i386.cfg menu.cfg ||vimdiff default.i386.cfg menu.cfg

diffx: diff
	diff -q grub.cfg grubtemp||vimdiff grub.cfg grubtemp
