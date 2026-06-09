#!/bin/bash

set -euo pipefail

FASTA=$1
GFF=$2
OUT="standard.interval_list"

if [[ -z "$FASTA" || -z "$GFF" ]]; then
  echo "Usage: bash generate_standard_intervals.sh <fna> <gff>"
  exit 1
fi

echo "Generating STANDARD interval list..."

java -Xmx40g -jar interval_tool.jar \
  GffFeaturesToIntervalList \
  -g "$GFF" \
  -r "$FASTA" \
  -o "$OUT" \
  -l 5S:5S \
  -l s-rRNA:12S \
  -l l-rRNA:16S \
  -l 5.8S:5.8S \
  -l 18S:18S \
  -l 28S:28S \
  -l 45S:45S \
  -i tRNA:tRNA \
  -i lnc_RNA:ncRNA \
  -i miRNA:ncRNA \
  -i snoRNA:ncRNA \
  -i snRNA:ncRNA \
  -i antisense_RNA:ncRNA

echo "Done -> $OUT"
