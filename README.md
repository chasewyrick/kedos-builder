Kedos Builder
=============

This script is used to build Kedos using Live Build(lb):

0. Downloads Ubuntu.iso.
0. Copies Kedos system binaries and configuration files into the mix.
0. Builds a custom iso file containing Kedos files and execluding unwanted packages. 

The builder is WIP. It does not generate an .iso at the moment.

Building
-----------

You need Kedos binaries and files in a .signedpackage format inside of system directory.
Then run: 

```
sudo chmod +x build.sh && sudo ./build.sh
```
