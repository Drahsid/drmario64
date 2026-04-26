#!/usr/bin/env python3

# SPDX-FileCopyrightText: © 2022 AngheloAlf
# SPDX-License-Identifier: MIT

from __future__ import annotations

import argparse
import mapfile_parser
from pathlib import Path
import rabbitizer


def decodeInstruction(bytesDiff: bytes, mapFile: mapfile_parser.MapFile) -> str:
    word = (bytesDiff[0] << 24) | (bytesDiff[1] << 16) | (bytesDiff[2] << 8) | (bytesDiff[3] << 0)
    instr = rabbitizer.Instruction(word)
    immOverride = None

    if instr.isJumpWithAddress():
        # Instruction is a function call (jal)

        # Get the embedded address of the function call
        symAddress = instr.getInstrIndexAsVram()

        # Search for the address in the mapfile
        symInfo = mapFile.findSymbolByVramOrVrom(symAddress)
        if symInfo is not None:
            # Use the symbol from the mapfile instead of a raw value
            immOverride = symInfo.symbol.name

    return instr.disassemble(immOverride=immOverride, extraLJust=-20)


def plfResolver(x: Path) -> Path|None:
    if x.suffix == ".plf":
        plf_map_path = x.with_suffix(".map")
        if plf_map_path.exists():
            return plf_map_path
    return None


def firstDiffMain():
    parser = argparse.ArgumentParser(description="Find the first difference(s) between the built ROM and the base ROM.")

    parser.add_argument("-c", "--count", type=int, default=5, help="find up to this many instruction difference(s)")
    parser.add_argument("-v", "--version", help="Which version should be processed", default="us")
    parser.add_argument("-a", "--add-colons", action='store_true', help="Add colon between bytes" )

    args = parser.parse_args()

    buildFolder = Path("build")

    BUILTROM = buildFolder / args.version / f"drmario64_uncompressed.{args.version}.z64"
    BUILTMAP = buildFolder / args.version / f"drmario64.{args.version}.map"

    EXPECTEDROM = "expected" / BUILTROM
    EXPECTEDMAP = "expected" / BUILTMAP

    ret = mapfile_parser.frontends.first_diff.doFirstDiff(
        BUILTMAP,
        EXPECTEDMAP,
        BUILTROM,
        EXPECTEDROM,
        args.count,
        mismatchSize=True,
        addColons=args.add_colons,
        bytesConverterCallback=decodeInstruction,
        plfResolver=plfResolver,
        plfResolverExpected=plfResolver,
    )
    exit(ret)

if __name__ == "__main__":
    firstDiffMain()
