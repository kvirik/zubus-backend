#!/bin/sh
gcc -c -fPIC -I/usr/local/gtm gtmapp.c
gcc -o gtmapp gtmapp.o
cp gtmapp /usr/lib/cgi-bin/
