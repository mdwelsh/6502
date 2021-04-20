#!/usr/bin/env python

import argparse
import math
import sys

from PIL import Image


BYTES_PER_COL = 8


def a2convert(r: int, g: int, b: int) -> int:
    if r == 0 and g == 0 and b == 0:
        return 0
    else:
        return 1


def process_image(infile, outfile, name, width, height):
    img = Image.open(infile)
    img = img.convert("RGB")
    img = img.resize((width, height), resample=Image.NEAREST)
    print(f"MDW: image size is now {img.size}")

    pixels = list(img.getdata())
    print(f"MDW: THERE ARE {len(pixels)} pixels")

    curpixel = 0
    shift = 7

    with open(outfile, "w+") as outf:
        outf.write(
            f"; Generated by img2hgr.py --name {name} --width {width} "
            f"--height {height} {infile} {outfile}\n"
        )
        col = 0
        outf.write(f"{name}:\n")
        for pixel in pixels:
            r, g, b = pixel
            if r >= 128 or g >= 128 or b >= 128:
                curpixel = curpixel | (1 << shift-1)

            shift = shift - 1
            if shift == 0:
                # Finished with output byte
                if col == 0:
                    outf.write("  .byte ")
                outf.write(f"${curpixel:02x}")
                col += 1
                if col < BYTES_PER_COL:
                    outf.write(",")
                else:
                    outf.write("\n")
                    col = 0
                shift = 7
                curpixel = 0

        outf.write("\n")
    print(f"Saved assembly to {outfile}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--name", type=str, required=True)
    parser.add_argument("--width", type=int, default=280)
    parser.add_argument("--height", type=int, default=192)
    parser.add_argument("infile")
    parser.add_argument("outfile")
    args = parser.parse_args()

    process_image(
        args.infile,
        args.outfile,
        args.name,
        args.width,
        args.height,
    )


if __name__ == "__main__":
    main()
