#!/bin/bash

set +e

rm /data/slurm/tmmap/hichip_out/*/anchor*
rm /data/slurm/tmmap/hichip_out/*/ep.bed
rm /data/slurm/tmmap/hichip_out/*/epgwas.*
rm /data/slurm/tmmap/hichip_out/*/epgene*
rm /data/slurm/tmmap/hichip_out/*/eprank*
rm /data/slurm/tmmap/hichip_out/*/gene*
rm /data/slurm/tmmap/hichip_out/GSM*/Matrix_BinSize*/Matrix*
rm /data/slurm/tmmap/hichip_out/GSM*/GSM*.macs2_peaks.xls
rm /data/slurm/tmmap/hichip_out/GSM*/GSM*.primary.aln.bed
rm /data/slurm/tmmap/hichip_out/GSM*/hicpro_mapped.pairs.gz
rm /data/slurm/tmmap/hichip_out/GSM*/Parameters.txt
rm /data/slurm/tmmap/hichip_out/GSM*/Matrix_BinSize*/GSM*.interactions.initial.bed
rm /data/slurm/tmmap/hichip_out/*/NormFeatures/Coverage_Bias/*Bias*
rm /data/slurm/tmmap/hichip_out/*/NormFeatures/*bed*
rm /data/slurm/tmmap/hichip_out/*/FitHiChIP_Peak2ALL_b*_L4600_U1000000000/P2PBckgr_0/Coverage_Bias/FitHiC_BiasCorr/configuration.txt
rm /data/slurm/tmmap/hichip_out/*/FitHiChIP_Peak2ALL_b*_L4600_U1000000000/P2PBckgr_0/Coverage_Bias/FitHiC_BiasCorr/Bin_Info.log
rm /data/slurm/tmmap/hichip_out/*/FitHiChIP_Peak2ALL_b*_L4600_U1000000000/P2PBckgr_0/Coverage_Bias/FitHiC_BiasCorr/MappableBinCountChr.bed
rm /data/slurm/tmmap/hichip_out/GSM*/FitHiChIP_Peak2ALL_b*_L4600_U1000000000/P2PBckgr_0/Coverage_Bias/Interactions*

rm /data/slurm/tmmap/chiapet_out/*/out/anchor*
rm /data/slurm/tmmap/chiapet_out/*/out/ep.bed
rm /data/slurm/tmmap/chiapet_out/*/out/epgwas.*
rm /data/slurm/tmmap/chiapet_out/*/out/epgene*
rm /data/slurm/tmmap/chiapet_out/*/out/eprank*
rm /data/slurm/tmmap/chiapet_out/*/out/gene*
rm /data/slurm/tmmap/chiapet_out/GSM*/out/out.peak.compact
rm /data/slurm/tmmap/chiapet_out/GSM*/out/out.bedpe.selected.pet.txt
rm /data/slurm/tmmap/chiapet_out/GSM*/out/out.peak.bed
rm /data/slurm/tmmap/chiapet_out/GSM*/out/out.peak.long
rm /data/slurm/tmmap/chiapet_out/GSM*/out/out.bedpe.selected.unique.txt
rm /data/slurm/tmmap/chiapet_out/GSM*/out/out.cluster.filtered.validunique.anchor

rm /data/slurm/tmmap/gene.txt
set -e
