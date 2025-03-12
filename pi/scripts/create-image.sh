#!/bin/bash

pwd

diskutil unmountDisk /dev/disk4
    
/Applications/Raspberry\ Pi\ Imager.app/Contents/MacOS/rpi-imager \
    --cli \
    --debug \
    --first-run-script pi/image/firstrun.sh \
    pi/image/2024-11-19-raspios-bookworm-armhf-lite.img.xz \
    /dev/disk4