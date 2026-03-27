# RGBtoHDMI Open Audio
## This is Open Hardware!

This is an open hardware audio interface for the popular RGBtoHDMI device.
RGBtoHDMI allows the use of many old computer systems with a modern HDMI display. The currently developed fork can be found here:
https://github.com/IanSB/RGBtoHDMI

A recent addition to the system's functionality has been to allow the injection of analogue audio to the HDMI connection. The software to do this is all covered by the GPL, but the hardware necessary is only available through select vendors.
This is an open version of the hardware which can be produced independently. It does not have all of the functionality of the original hardware, but this means it is marginally simpler and cheaper to produce.

Details of how the hardware can be attached to the RGBtoHDMI, and its usage, can be found in the official RGBtoHDMI wiki here: https://github.com/IanSB/RGBtoHDMI/wiki/Audio

The half-rate jumper is present (make link JP1). The facility to use a single GPIO is not present in this version (this was to accomodate use with a machine that wished to use the OSD option for FlashFloppy).

To support audio, you must use the latest beta release of the RGBtoHDMI software from here: https://github.com/IanSB/RGBtoHDMI/releases

## Plain-English Summary of the CERN Open Hardware Licence – Strongly Reciprocal (CERN-OHL-S v2)

Under the **CERN Open Hardware Licence – Strongly Reciprocal (CERN-OHL-S v2)**, **you are allowed to**: 

- use the design for any purpose, including research, teaching, hobby, and commercial use. 
- study how it works and learn from the design files.
- copy and share the design files with other people.
- modify, improve, or adapt the design to suit your needs.
- make physical products from the design.
- sell or distribute those products, including commercially.

### If you share it, you must also

If you share the design, share a modified version, or distribute a product made from it, you must: 
- make the complete source/design files available to the recipient. 
- license the covered design files and modifications under the same licence.
- keep the existing copyright and licence notices.
- clearly state what you changed and when you changed it.
- tell people where they can find the source files if you are not providing them directly with the product.

### What this means in practice

In simple terms: **you can use it, copy it, modify it, make it, and sell products based on it — but if you pass it on, you must keep the design files open under the same licence.** 

### Important note

This is a **plain-English summary only** and is **not a substitute for the full licence text**. https://cern-ohl.web.cern.ch/

## Details
The audio system is based around a Texas Instruments PCM1808 ADC IC (https://www.ti.com/lit/ds/symlink/pcm1808.pdf) with a 12.288MHz oscillator. It requires 5V and 3.3V supplies, both of which are taken from the Rasperry Pi GPIO. Three data pins are required - BCK (the bitclock), LRCK (left/right clock) and DOUT (the audio data). As the RGBtoHDMI software can cope with the LRCK and DOUT being multiplexed to one pin, the software is set up in such a way that it uses the edges of the BCK signal to clock the data rate, rather than the high/low, to clock the data. Consequently the BCK rate must be halved before it reaches the Pi GPIO. This is achieved using a 74LVC1G80 flipflop. Other components provide relevant pullups, power cleaning, and audio filters as specified in the PCM1808 data sheet.  One jumper connection is available (JP1) - making this connection will have the sample rate of the PCM1808 (24KHz instead of 48KHz).


### Front (prototype)
<img width="1739" height="793" alt="Screenshot 2026-03-27 175502" src="https://github.com/user-attachments/assets/04423713-9d66-43f3-bbb3-543eeae2d605" />

### Back
<img width="1704" height="888" alt="Screenshot 2026-03-27 175520" src="https://github.com/user-attachments/assets/7b45f41c-1b5b-4cbf-9e70-16f459a1500a" />

