[![Build Status](https://travis-ci.org/hildred/unboot.svg?branch=master)](https://travis-ci.org/hildred/unboot)

unboot
======

Universal Network Boot
The Goal of this project is to be able to network boot any computer that is
network bootable, load a boot menu and boot the selected image from a list of
all the operating systems that can be network booted including live images and
installers. The list of operating systems should be platform correct (PowerPC
computers should not try to boot dos or windows and Intel platforms should not
try to boot OS9) and user friendly (have help, basic and advanced options).

We have some way to go on this in that the most powerful boot loader (ipxe) is
Intel BIOS only, and I have not yet got grub2 to boot a PowerPC. Arm is still a
pipe dream. EFI needs work. Windows is partially working.

The two major pieces so far are the dhcp configuration and the meta-menu
generation system.

The dhcp configuration file is for client hardware detection. It tells the boot
ROM the hardware appropriate boot image to use.

The meta-menu system takes a list of boot entries and creates configuration
files for multiple boot loaders. It is internationalized, and can create
localized menus and translation templates.

Note to translators:
----

As the localization is untested I would appreciate a test translation in any
language. Also note that I use multiple domains, one for the server based tools,
and a separate domain for client menus.

Menu file format:
----

The menu file is a sequence of sections containing key value pairs. The first
section must be untagged and is used for configuration. The remaining sections
are marked with a section tag surrounded by square brackets on a otherwise empty
line. Comment lines may be marked with either a hash, semicolon or double slash
before any non-whitespace character and will be ignored as will empty lines.
Values are assigned to keys on a single line having the key name an equals sign
and the value. The key may not contain whitespace and is case insensitive.
Leading and trailing whitespace is stripped from both key and value.
The context key if used must be before any translateble strings in that section.
All other keys may be in any order. No special marking is needed to denote
translatable strings, as titles labels and hot keys are automaticaly marked for
translation. No other values are translated. Translation may be bypassed by
setting the global lang key, in which case the menu is assumed to be localized.
