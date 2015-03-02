
all: grub.cfg menu.ipxe default.i386.cfg default.amd64.cfg unboot.pot
extra: grubtemp grub
.PHONY:
.SECONDARY:
LOCALIZABLE=./buildmenu

test: all
	true

grub:
	grub-mknetdir --compress=xz --net-directory=/tftpboot --subdir=grub --modules="bufio normal boot gfxterm video video_fb png echo multiboot bsd echo cpuid gzio minicmd test"

%.set: %.grub %.ipxe %.slcfg

%.grub: %.menu buildmenu grub.lib
	./buildmenu grub $< > $@

%.ipxe: %.menu buildmenu ipxe.lib
	./buildmenu ipxe $< > $@

%.slcfg: %.menu buildmenu pxelinux.lib
	./buildmenu pxelinux $< > $@

unboot.pot: $(LOCALIZABLE)
	xgettext -L Perl \
	    -k__ -k\$__ -k%__ -k__n:1,2 -k__nx:1,2 -k__np:2,3 -k__npx:2,3 -k__p:2 \
	    -k__px:2 -k__x -k__xn:1,2 -kN__ -kN__n -kN__np -kN__p -k \
	    --from-code utf-8 -o $@ $(LOCALIZABLE)

%.pot: %.menu buildmenu pot.lib
	./buildmenu pot $< > $@

menufile.pot: menufile buildmenu pot.lib
	./buildmenu pot menufile > $@

grub.cfg: buildmenu menufile grub.lib
	./buildmenu grub menufile > $@

menu.ipxe: buildmenu menufile ipxe.lib
	./buildmenu ipxe menufile > $@

default.cfg: buildmenu menufile pxelinux.lib
	./buildmenu pxelinux menufile > $@

grubtemp: /etc/grub.d/* /usr/sbin/grub-mkconfig
	sudo grub-mkconfig > $@

default.i386.cfg: default.cfg Makefile expandvars
	./expandvars arch=i386 pxe_default_server=192.168.0.1 video=gtk dvideo='dvideo video=vesa:ywrap,mtrr vga=788' ddesktop=xfce ddebug= dpreseed= dmode='-- quiet' $< > $@

default.amd64.cfg: default.cfg Makefile expandvars
	./expandvars arch=amd64 pxe_default_server=192.168.0.1 video=gtk dvideo='dvideo video=vesa:ywrap,mtrr vga=788' ddesktop=xfce ddebug= dpreseed= dmode='-- quiet' $< > $@

#diff: all
#	diff -q menu.ipxe boot.hold|| gvimdiff -f menu.ipxe boot.hold
#	diff -q default.cfg menu.cfg ||gvimdiff -f default.cfg menu.cfg
diff: all debhd.grub
	diff -q menu.ipxe boot|| gvimdiff -f menu.ipxe boot
	diff -q grub.cfg ../tftpboot/grub2/grub.cfg||gvimdiff -f grub.cfg ../tftpboot/grub2/grub.cfg
	diff -q grubtemp /boot/grub/grub.cfg ||EDITOR='gvimdiff -f grubtemp' sudoedit /boot/grub/grub.cfg
	diff -q default.i386.cfg menu.cfg ||gvimdiff -f default.i386.cfg menu.cfg
	diff -q debhd.grub grubtemp||gvimdiff -f debhd.grub grubtemp

diffx: diff
	diff -q grub.cfg grubtemp||gvimdiff -f grub.cfg grubtemp
