#!/usr/bin/env python3
from PIL import Image
import os
import sys
import re

input_file = sys.argv[1]
output_file = os.path.splitext(input_file)[0] + ".png"
img = Image.new("RGB", (1920, 1080))
pixels = img.load()
regex = re.compile(r'^(\d+),(\d+),(\d+)')

with open(input_file) as txt:
    for y in range(img.size[1]):
        sys.stderr.write("\rconverting... %d%%" % (y * 100 / img.size[1]))
        for x in range(img.size[0]):
            m = regex.match(txt.readline())
            pixels[x,y] = (int(m.group(1)), int(m.group(2)), int(m.group(3)))
sys.stderr.write("\n")

img.save(output_file)
