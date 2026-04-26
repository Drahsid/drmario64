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


def mapToPj64symsMain():
    parser = argparse.ArgumentParser()
    parser.add_argument("-v", "--version", help="version to process", default="us")
    parser.add_argument("-o", "--output", default="DR.MARIO 64.sym", type=Path)

    args = parser.parse_args()

    version: str = args.version
    output: Path = args.output
    mapPath = Path("build") / args.version / f"drmario64.{version}.map"

    ret = mapfile_parser.frontends.pj64_syms.doPj64Syms(mapPath, output, plfResolver=plfResolver)
    exit(ret)

if __name__ == "__main__":
    mapToPj64symsMain()
