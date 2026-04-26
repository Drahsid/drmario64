#!/usr/bin/env python3

# SPDX-FileCopyrightText: © 2022 AngheloAlf
# SPDX-License-Identifier: MIT

from __future__ import annotations

import argparse
import mapfile_parser
from pathlib import Path


def plfResolver(x: Path) -> Path|None:
    if x.suffix == ".plf":
        plf_map_path = x.with_suffix(".map")
        if plf_map_path.exists():
            return plf_map_path
    return None


def symInfoMain():
    parser = argparse.ArgumentParser(description="Display various information about a symbol or address.")
    parser.add_argument("symname", help="symbol name or VROM/VRAM address to lookup")
    parser.add_argument("-e", "--expected", dest="use_expected", action="store_true", help="use the map file in expected/build/ instead of build/")
    parser.add_argument("-v", "--version", help="Which version should be processed", default="us")

    args = parser.parse_args()

    BUILTMAP = Path("build") / args.version / f"drmario64.{args.version}.map"

    mapPath = BUILTMAP
    if args.use_expected:
        mapPath = "expected" / BUILTMAP

    ret = mapfile_parser.frontends.sym_info.doSymInfo(
        mapPath,
        args.symname,
        plfResolver=plfResolver,
    )
    exit(ret)

if __name__ == "__main__":
    symInfoMain()
