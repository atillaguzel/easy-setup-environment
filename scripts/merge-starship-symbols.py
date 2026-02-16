#!/usr/bin/env python3
"""Merge Nerd Font symbols from the Starship preset into our config.

Usage: python3 merge-starship-symbols.py <config_file> <preset_file>

For each section in the preset, if that section exists in our config,
replace/add the key=value lines. If the section doesn't exist, append it.
"""
import re
import sys


def main():
    config_file = sys.argv[1]
    preset_file = sys.argv[2]

    # Parse preset: {section_header: {key: full_line}}
    with open(preset_file, encoding="utf-8") as f:
        preset_data = {}
        section = None
        for raw in f:
            line = raw.rstrip("\n")
            m = re.match(r"^\[.+\]$", line.strip())
            if m:
                section = line.strip()
                preset_data.setdefault(section, {})
            elif section and "=" in line and not line.strip().startswith("#"):
                key = line.split("=", 1)[0].strip()
                preset_data[section][key] = line

    # Read config
    with open(config_file, encoding="utf-8") as f:
        config_lines = f.readlines()

    # Merge: walk config, replace matching keys with preset values
    result = []
    section = None
    seen_sections = set()

    for raw in config_lines:
        line = raw.rstrip("\n")
        m = re.match(r"^\[.+\]$", line.strip())
        if m:
            section = line.strip()
            seen_sections.add(section)
            result.append(raw)
            continue

        # If this line's key exists in the preset for the current section, replace it
        if (
            section
            and section in preset_data
            and "=" in line
            and not line.strip().startswith("#")
        ):
            key = line.split("=", 1)[0].strip()
            if key in preset_data[section]:
                result.append(preset_data[section].pop(key) + "\n")
                continue

        result.append(raw)

    # Append preset sections that don't exist in our config at all
    for sect, keys in preset_data.items():
        if sect not in seen_sections and keys:
            result.append("\n")
            result.append(sect + "\n")
            for key_line in keys.values():
                result.append(key_line + "\n")

    # Write merged config
    with open(config_file, "w", encoding="utf-8") as f:
        f.writelines(result)

    print(f"Merged {preset_file} symbols into {config_file}")


if __name__ == "__main__":
    main()
