while read line; 
do
    echo "Processing GSM: $line"
    python3 /data/slurm/tmmap/hichip/FitHiChIP/src/CombineNearbyInteraction.py \
    --InpFile /data/slurm/tmmap/chiapet_out/${line}/out/out.cluster.FDRfiltered.txt \
    --OutFile /data/slurm/tmmap/chiapet_out/${line}/out/merged_out.cluster.FDRfiltered.txt \
    --headerInp 0 --binsize 2500 --percent 100 --Neigh 2 

done < /data/slurm/tmmap/chiapet.txt
