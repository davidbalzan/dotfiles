#!/usr/bin/env python3
"""Map a hex color to the closest papirus-folders color name."""
import sys, colorsys

PAPIRUS_COLORS = {
    "blue":       0x5294e2,
    "black":      0x3e3e3e,
    "bluegrey":   0x607d8b,
    "brown":      0x8d6e63,
    "cyan":       0x00bcd4,
    "darkcyan":   0x00838f,
    "deeporange": 0xff5722,
    "green":      0x4caf50,
    "grey":       0x9e9e9e,
    "indigo":     0x3f51b5,
    "magenta":    0xe91e63,
    "orange":     0xff9800,
    "pink":       0xf06292,
    "red":        0xf44336,
    "teal":       0x009688,
    "violet":     0x9c27b0,
    "yellow":     0xffeb3b,
    "adwaita":    0x3584e4,
    "breeze":     0x3daee9,
}

def hex_to_rgb(h):
    return ((h >> 16) & 0xff, (h >> 8) & 0xff, h & 0xff)

def hue_distance(h1, h2):
    d = abs(h1 - h2)
    return min(d, 1.0 - d)

def color_distance(c1_hex, c2_hex):
    r1, g1, b1 = [x/255.0 for x in hex_to_rgb(c1_hex)]
    r2, g2, b2 = [x/255.0 for x in hex_to_rgb(c2_hex)]
    h1, s1, l1 = colorsys.rgb_to_hls(r1, g1, b1)
    h2, s2, l2 = colorsys.rgb_to_hls(r2, g2, b2)
    return (hue_distance(h1, h2) * 3.0) ** 2 + (s1 - s2) ** 2 + (l1 - l2) ** 2 * 0.5

hex_input = sys.argv[1].lstrip('#')
target = int(hex_input, 16)

_, s, _ = colorsys.rgb_to_hls(*[x/255.0 for x in hex_to_rgb(target)])
candidates = PAPIRUS_COLORS
if s > 0.2:
    candidates = {k: v for k, v in candidates.items() if k not in ('black', 'grey')}

best = min(candidates.items(), key=lambda x: color_distance(target, x[1]))
print(best[0])
