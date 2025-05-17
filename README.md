# gardOS version 3.0 generic.
about this project:
16 bit operating system made by Gabriel sîrbu.
things needed to try gardOS out:
use nasm to assmble this project by running „sudo apt install nasm” to install nasm
also install QEMU emulator to test this OS out
if you don't have QEMU but have an secondary computer (BIOS, not UEFI!) you can test on it. but if the secondary computer runs UEFI you can unable CSM to run gardOS
to test out in secondary computer folow these steps:
1. get Rufus (Windows) or Balena etcher (Linux)
    using rufus or balena etcher write gardOS on an thumb drive with 2-3 GiB
3. on the secondary computer press the special button to get into the boot menu (Asus (from around 2010) => esc, Lenovo (new ones) => Fn+F12)
4. in boot menu select your thumb drive
5. enjoy gardOS!
