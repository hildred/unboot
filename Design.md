Client Server Booting
----

The first thing to remember in Network Booting is that there is more than one
computer involved. This has advantages, but it can add complexity. This project
is intended to maximize the advantages of network booting, manage the
complexity, and address some of the shortcomings of software in the field.

The first goal is to not over simplify. Using Microsoft's tools for network
booting works great for booting Windows, can with much work be used to boot
Linux, But is completely useless for booting OS-X. Apple's tools are similar in
scope if different in target. These and other vendors seek to limit complexity
by ignoring it. They say, "This is the way we do it here. We don't care if it
does not work with their software, that is outside our scope." Our stance is
broader. We want to design a system that works with all the computers in an
organization, with an emphasis on open source.

The second goal is user interface. There are three parts to this. First is to
have it just work. The user that knows what he wants should be able to do it
without difficulty. The second is perceived simplicity. The user should be able
in his native language to think no more deeply than he wants to. The third is
available complexity. It was better said that "it makes simple things easy and
difficult things possible."

Now to limit our scope. The core protocols we are going to use are dhcp and
tftp. That is if it does not use those protocols, we will not support it.
Additionally we may use http, iscsi, and aoe if they are available. Further we
will endorse but not directly use ssh as the remote administration protocol.

To maximize code reuse we will use common open source software wherever
possible, contributing changes back where improvements are needed to meet our
requirements. Specifically we will use ISC's dhcp server, any tftp server and
any http server as our server components. Client side we will use the hardware
vendor's boot client whenever possible, iPXE on those machines where it will run
but there is not a vendor client, and whatever we can find on other hardware.

Now a brief detour into philosophy. There are three concepts associated with
boot loaders, they are boot straps, boot menus, and boot monitors. A boot strap
is responsible for loading an operating system. It does not need to present any
messages to the user beyond progress messages during normal operation. It may
present error messages which are so cryptic that reference works must be
consulted to determine their meaning without sacrificing usability, because
there is no recovery anyway. A boot menu on the other hand is designed to
interact with the user, namely it displays a menu and the user makes a choice.
At this point the boot menu either becomes or invokes a boot strap. A boot
monitor may also be a boot strap or a boot menu, but is identified by the
ability to do specific tasks to configure a system, recover a system that will
not boot or do low level diagnostics. Our goal is to use a boot menu wherever
possible. A boot strap may be used directly if there is not a open source boot
menu available. If there is boot monitor functionality available we will take
advantage of it as long as it does not interfere with our other goals. We will
make no significant effort to make the boot monitor user friendly, as that falls
into the category of hard things possible.

Although we may write boot menus for places where they are not available, We
will use existing ones wherever possible, specifically we will use iPXE, grub,
and pxelinux. Other boot menus and boot straps are under consideration for other
platforms.

Pieces of the puzzle that need to be made
---

The first piece is a configuration file for ISC's dhcp server to allow it to net
boot as many different hardware platforms as possible. Also needed are other
server side configuration tools to make the preparation of configuration files
and boot images as easy as possible.

The second piece is a high level boot language. So far without any effort I have
found at least six different languages or notations for writing boot menus. All
of them are completely incompatible. I have quit counting, instead I have
decided to write a domain specific language for describing basic boot menus that
can be compiled to any menu specific language. This is a work in progress.

