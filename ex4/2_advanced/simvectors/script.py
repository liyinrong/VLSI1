#!/usr/bin/python

import cv2
import csv
import numpy as np
from os import path


def saturate(file_name, scale):
    pic = cv2.imread(file_name)

    apic = pic
    pic32 = apic.astype(np.uint32)
    RWEIGHT = 74
    GWEIGHT = 145
    BWEIGHT = 36

    gray_scale_pic = pic32[:, :, 2] * RWEIGHT + pic32[:, :, 1] * GWEIGHT + pic32[:, :, 0] * BWEIGHT
    gray_scale_pic = np.floor(gray_scale_pic.astype(np.double) / 256).astype(np.uint32).astype(np.uint8)

    pics16 = apic.astype(np.int16)
    gray_scale_pic_s16 = gray_scale_pic.astype(np.int16)

    r_delta = pics16[:, :, 2] - gray_scale_pic_s16
    g_delta = pics16[:, :, 1] - gray_scale_pic_s16
    b_delta = pics16[:, :, 0] - gray_scale_pic_s16

    r_delta = r_delta * scale + gray_scale_pic_s16
    g_delta = g_delta * scale + gray_scale_pic_s16
    b_delta = b_delta * scale + gray_scale_pic_s16

    sat_pic = pic
    sat_pic[:, :, 2] = r_delta.astype(np.uint8)
    sat_pic[:, :, 1] = g_delta.astype(np.uint8)
    sat_pic[:, :, 0] = b_delta.astype(np.uint8)
    return sat_pic


def png2ascii(in_file_name):
    pic = cv2.imread(in_file_name)
    unrolled_image = [rgb for sublist in pic for rgb in sublist]
    with open(in_file_name[:-3] + "txt", 'w') as csvfile:
        writer = csv.writer(csvfile, lineterminator="\n")
        for i in unrolled_image:
            writer.writerow([i[2], i[1], i[0]])
    return unrolled_image


def ascii2png(in_file_name, ref_png):
    ref_png = cv2.imread(ref_png)
    unrolled_image = []
    with open(in_file_name, 'r') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            unrolled_image.append([int(row[2]), int(row[1]), int(row[0])])
    for i in range(len(ref_png) * len(ref_png[0]) - len(unrolled_image)):
        unrolled_image.append([0, 0, 0])

    rolled_image = np.array(unrolled_image).reshape(ref_png.shape)
    cv2.imwrite(in_file_name[:-3] + "png", rolled_image)
    return rolled_image


def main():
    # Create ASCII stimulus file
    png2ascii("faded_lake.png")

    # Create expected output picture
    sat_pic = saturate("faded_lake.png", 3)
    cv2.imwrite("sat_lake.png", sat_pic)

    # Create expected response ASCII file
    png2ascii("sat_lake.png")

    # Create PNG image from actual response (if exists)
    if (path.exists("output.txt")):
        ascii2png("output.txt", "faded_lake.png")


if __name__ == '__main__':
    main()
