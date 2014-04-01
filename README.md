unboot
======

Universal Network Boot

The Goal of this project is to be able to network boot any computer that is network bootable, load a boot menu
and boot the selected image from a list of all the operating systems that can be network booted including live images and
installers. The list of operating systems should be platform correct (PowerPC computers should not try to boot dos or
windows and intel platforms should not try to boot OS9) and user friendly (have help, basic and advanced options).

We have some way to go on this in that the most powerful boot loader (ipxe) is intel bios only, and I have not yet got
grub2 to boot a PowerPC. Arm is still a pipe dream. EFI needs work. Windows is partialy working.

The two major pieces so far are the dhcp configuration and the meta-menu generation system.
