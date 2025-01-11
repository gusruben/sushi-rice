#!/bin/sh
# pactl list
~/.config/polybar/scripts/pulseaudio-control \
    --format '%{F#ef4c80}$NODE_NICKNAME  $VOL_ICON%{F-} $MUTED_OR_DEFAULT${VOL_LEVEL}% $END_COLOR' \
    \
    --icon-muted "" \
    --icons-volume "," \
    --color-muted 8c8c8c \
    \
    --node-nickname "alsa_output.pci-0000_00_1f.3.analog-stereo:蓼" \
    --node-nickname "alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1:" \
    --node-nickname "bluez_sink.00_14_BE_31_C7_1D.a2dp_sink:" \
	\
	--node-nickname "alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink:" \
    \
    listen 
