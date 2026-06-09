# Author: Oliver Abinader


# Genome Interval List Generator

A collection of workflows for generating **standard and non-standard genomic interval lists** from reference genome annotations. These interval lists are commonly used in RNA-seq preprocessing, rRNA depletion strategies, and targeted sequence filtering workflows.


## Overview

This repository provides standardized methods to construct interval lists from genome annotation files (GFF/GTF and FASTA references). These interval lists define genomic regions used for:

* rRNA depletion design
* Gene and transcript filtering
* Annotation-based read exclusion or enrichment
* Downstream sequencing analysis optimization

Two main types of interval lists are generated:

### 1. Standard Interval List

A simplified interval representation derived from genome annotations that excludes gene-level naming complexity. Primarily used for **rRNA-focused depletion strategies** and general region masking.

### 2. Non-Standard Interval List

A comprehensive interval representation that includes:

* Genes of interest for depletion
* rRNA, tRNA, ncRNA regions
* CDS, UTR, intronic, and intergenic regions
* Custom gene sets (e.g., ribosomal or mitochondrial targets)


## Inputs Required

All workflows require the following reference files:

* Genome FASTA file (`.fna` / `.fa`)
* FASTA index (`.fai`)
* Sequence dictionary (`.dict`)
* Genome annotation file (`.gff` or `.gtf`)
* Optional gene list file (for targeted depletion sets)


# Standard Interval List Generation

The standard interval list focuses on ribosomal RNA regions _and selected ncRNA classes_.

### Key Features

* Excludes gene-level naming complexity
* Focuses on rRNA and structural RNA annotations
* Used for baseline depletion reference generation

### Workflow

Run the following script in a directory containing the reference genome files:

```bash
bash scripts/generate_standard_intervals.sh <path_to_fna> <path_to_gff>
```

### Output

* `standard.interval_list`

### Validation

To check whether an interval list is standard:

```bash
cat interval_list | grep -v "@" | awk '{print $5}' | sort | uniq -c
```

* If gene names are present → **Non-standard interval list**
* If no gene names are present → **Standard interval list**


# Non-Standard Interval List Generation

The non-standard interval list includes gene-level and region-level annotations for targeted depletion strategies.

### Key Features

* Includes gene-specific depletion targets
* Supports custom gene lists (e.g., ribosomal, mitochondrial, curated panels)
* Includes genomic features such as CDS, UTR, introns, and ncRNAs

### Input Gene List

A file containing gene names to be targeted for depletion (e.g., ribosomal, mitochondrial, or custom gene sets).

Example:

```
RiboMito
NVG
i500
```


### Workflow

Run the pipeline:

```bash
bash scripts/generate_nonstandard_intervals.sh \
    <path_to_fna> \
    <path_to_gene_list>
```


### Outputs

The pipeline generates multiple intermediate and final files:

* `interim.gff`
* `interim.interval_list`
* `*.exclude.interval_list`
* `*.missed-genes.txt`
* `*.interval_list` (final output)

Final output:

```
GCF_000001405.39_GRCh38.p13_genomic.all.interval_list
```

This file should be renamed to:

```
genomic.all.interval_list
```


### Validation Checks

1. Ensure no missing genes:

```bash
cat missed-genes.txt
```

This file should ideally be empty.


2. Verify completeness:

The non-standard interval list should contain **more entries** than the standard interval list:

```bash
wc -l standard.interval_list
wc -l genomic.all.interval_list
```

Expected:

```
non-standard > standard
```


## Interpretation

### Standard Interval List

Used when:

* Only rRNA depletion is required

### Non-Standard Interval List

Used when:

* Gene-level depletion is required
* Custom gene sets are targeted


## Directory Recommendation

It is recommended to place interval list generation outputs in:

```
same directory as reference FASTA/GFF files
```

OR in a structured reference folder:

```
/reference/genome/
/reference/interval_lists/
```

This ensures reproducibility and consistent pathing across pipelines.


## Notes

* Ensure FASTA, GFF, and dictionary files correspond to the same genome build.
* Always verify annotation consistency before generating interval lists.
* Keep gene list files version-controlled for reproducibility.
