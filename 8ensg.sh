#!/bin/bash

declare -A enst_to_ensg
while IFS=$'\t' read -r enst ensg species gene_name; do
    enst_to_ensg["$enst"]=$ensg
done < <(tail -n +2 /data/slurm/tmmap/references/convert.txt)

while read line;
do
  echo "${line}"
  > /data/slurm/tmmap/chiapet_out/${line}/out/ensg.txt
  while IFS='.' read -r enst _; do
      if [[ -n "${enst_to_ensg[$enst]}" ]]; then 
          echo -e "${enst_to_ensg[$enst]}" >> /data/slurm/tmmap/chiapet_out/${line}/out/ensg.txt
      fi
  done < /data/slurm/tmmap/chiapet_out/${line}/out/gene.txt
done < chiapet.txt

while read line;
do
  echo "${line}"
  > /data/slurm/tmmap/hichip_out/${line}/ensg.txt
  while IFS='.' read -r enst _; do
      if [[ -n "${enst_to_ensg[$enst]}" ]]; then 
          echo -e "${enst_to_ensg[$enst]}" >> /data/slurm/tmmap/hichip_out/${line}/ensg.txt
      fi
  done < /data/slurm/tmmap/hichip_out/${line}/gene.txt
done < hichip.txt

> /data/slurm/tmmap/allensg.txt
while IFS='.' read -r enst _; do
  if [[ -n "${enst_to_ensg[$enst]}" ]]; then 
    echo -e "${enst_to_ensg[$enst]}" >> /data/slurm/tmmap/allensg.txt
  fi
done < /data/slurm/tmmap/gene.txt  