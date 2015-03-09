
all: debian.set main.set unboot.pot
extra: grubtemp grub
.PHONY:
.SECONDARY:
LOCALIZABLE=./buildmenu

test: all
	true

grub:
	grub-mknetdir --compress=xz --net-directory=/tftpboot --subdir=grub --modules="bufio normal boot gfxterm video video_fb png echo echo gzio minicmd test"

%.set: %.grub %.ipxe %.i386.cfg %.amd64.cfg %.pot

%.grub: %.menu buildmenu grub.lib
	./buildmenu grub $< > $@

%.ipxe: %.menu buildmenu ipxe.lib
	./buildmenu ipxe $< > $@

%.slcfg: %.menu buildmenu pxelinux.lib
	./buildmenu pxelinux $< > $@

%.pot: %.menu buildmenu pot.lib
	./buildmenu pot $< > $@

%.i386.cfg: %.slcfg Makefile expandvars
	./expandvars arch=i386 pxe_default_server=192.168.0.1 video=gtk dvideo='dvideo video=vesa:ywrap,mtrr vga=788' ddesktop=xfce ddebug= dpreseed= dmode='-- quiet' $< > $@

%.amd64.cfg: %.slcfg Makefile expandvars
	./expandvars arch=amd64 pxe_default_server=192.168.0.1 video=gtk dvideo='dvideo video=vesa:ywrap,mtrr vga=788' ddesktop=xfce ddebug= dpreseed= dmode='-- quiet' $< > $@

unboot.pot: $(LOCALIZABLE)
	xgettext -L Perl \
	    -k__ -k\$__ -k%__ -k__n:1,2 -k__nx:1,2 -k__np:2,3 -k__npx:2,3 -k__p:2 \
	    -k__px:2 -k__x -k__xn:1,2 -kN__ -kN__n -kN__np -kN__p -k \
	    --from-code utf-8 -o $@ $(LOCALIZABLE)

grubtemp: /etc/grub.d/* /usr/sbin/grub-mkconfig
	sudo grub-mkconfig > $@

diff: all debhd.grub grubtemp
	diff -q menu.ipxe boot.hold|| gvimdiff -f menu.ipxe boot.hold
	diff -q main.slcfg menu.cfg ||gvimdiff -f main.slcfg menu.cfg
	diff -q menu.ipxe boot|| gvimdiff -f menu.ipxe boot
	diff -q main.grub ../tftpboot/grub2/grub.cfg||gvimdiff -f main.grub ../tftpboot/grub2/grub.cfg
	diff -q grubtemp /boot/grub/grub.cfg ||EDITOR='gvimdiff -f grubtemp' sudoedit /boot/grub/grub.cfg
	diff -q main.i386.cfg menu.cfg ||gvimdiff -f main.i386.cfg menu.cfg
	diff -q debhd.grub grubtemp||gvimdiff -f debhd.grub grubtemp

diffx: diff
	diff -q main.grub grubtemp||gvimdiff -f main.grub grubtemp
