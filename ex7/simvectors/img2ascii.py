#!/usr/bin/env python3
from PIL import Image
import os
import sys

input_file = sys.argv[1]
output_file = os.path.splitext(input_file)[0] + ".txt"
img = Image.open(input_file)
pixels = img.load()

with open(output_file, "w") as txt:
    for y in range(img.size[1]):
        sys.stderr.write("\rconverting... %d%%" % (y * 100 / img.size[1]))
        for x in range(img.size[0]):
            txt.write("%d,%d,%d\n" % pixels[x,y])
sys.stderr.write("\n")
