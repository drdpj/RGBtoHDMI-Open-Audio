#!/bin/bash
# REUSE-IgnoreStart
# --- Configuration ---
COPYRIGHT_HOLDER="Daniel Jameson"
SOURCE_LOCATION="https://github.com/drdpj/RGBtoHDMI-Open-Audio"
YEAR=$(date +%Y)

PREAMBLE="# SPDX-License-Identifier: CERN-OHL-S-2.0+
# SPDX-FileCopyrightText: ${YEAR} ${COPYRIGHT_HOLDER}
#
# This source describes Open Hardware and is licensed under the
# CERN-OHL-S v2 or any later version.
#
# You may redistribute and modify this source and make products
# using it under the terms of the CERN-OHL-S v2 or any later
# version (https://ohwr.org/cern_ohl_s_v2.txt).
#
# This source is distributed WITHOUT ANY EXPRESS OR IMPLIED
# WARRANTY, INCLUDING OF MERCHANTABILITY, SATISFACTORY QUALITY
# AND FITNESS FOR A PARTICULAR PURPOSE. Please see the CERN-OHL-S
# v2 for applicable conditions.
#
# Source location: ${SOURCE_LOCATION}
#
# As per CERN-OHL-S v2 section 4, should You produce hardware based
# on this source, You must where practicable maintain the Source
# Location visible on the external case of the hardware or other
# products you make using this source.
#"

# --- S-expression files ---
EXTENSIONS=("*.kicad_sch" "*.kicad_pcb")

for EXT in "${EXTENSIONS[@]}"; do
    find . -name "$EXT" | while read -r FILE; do
        
        if grep -Eq '^# SPDX-License-Identifier:' "$FILE"; then
            echo "SKIP (already licensed): $FILE"
            continue
        fi

        echo "Adding preamble: $FILE"
        TMP=$(mktemp)
        { echo "$PREAMBLE"; echo; cat "$FILE"; } > "$TMP" && mv "$TMP" "$FILE"
    done
done

# --- .kicad_pro JSON files ---
if ! command -v jq &>/dev/null; then
    echo "ERROR: 'jq' is required for .kicad_pro files. Install it with your package manager."
    exit 1
fi

find . -name "*.kicad_pro" | while read -r FILE; do
    if jq -e '.license' "$FILE" &>/dev/null; then
        echo "SKIP (already licensed): $FILE"
        continue
    fi
    echo "Adding license key: $FILE"
    TMP=$(mktemp)
    jq \
        --arg spdx "CERN-OHL-S-2.0+" \
        --arg copyright "${YEAR} ${COPYRIGHT_HOLDER}" \
        --arg source "${SOURCE_LOCATION}" \
        '. + {
            license: {
                spdx: $spdx,
                copyright: $copyright,
                source_location: $source
            }
        }' "$FILE" > "$TMP" && mv "$TMP" "$FILE"
done

echo "Done."
# REUSE-IgnoreEnd