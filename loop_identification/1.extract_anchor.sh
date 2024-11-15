while read line; 
do  
    echo "Processing GSM: $line"
    path="/data/slurm/tmmap/hichip_out/${line}/"
    awk 'BEGIN{OFS="\t"} NR > 1 {
        print $1, $2, $3, "a" (NR-1) > "'${path}'anchor1.bed";
        print $4, $5, $6, "A" (NR-1) > "'${path}'anchor2.bed";
    }' ${path}FitHiChIP_Peak2ALL_*/P2PBckgr_0/Coverage_Bias/FitHiC_BiasCorr/Merge_Nearby_Interactions/${line}.interactions_FitHiC_Q0.01_MergeNearContacts.bed
done < /data/slurm/tmmap/hichip.txt

while read line; 
do  
    echo "Processing GSM: $line"
    path="/data/slurm/tmmap/hichip_out/${line}/"
    awk 'BEGIN{OFS="\t"} NR > 1 {
        print $1, $2, $3, "a" (NR-1) > "'${path}'anchor1.bed";
        print $4, $5, $6, "A" (NR-1) > "'${path}'anchor2.bed";
    }' ${path}FitHiChIP_Peak2ALL_b5000_L4600_U1000000000/P2PBckgr_0/Coverage_Bias/FitHiC_BiasCorr/Merge_Nearby_Interactions/${line}.interactions_FitHiC_Q0.01_MergeNearContacts.bed
done < /data/slurm/tmmap/hichip_out/succeed_5000.txt

while read line; 
do  
    echo "Processing GSM: $line"
    path="/data/slurm/tmmap/chiapet_out/${line}/out/"
    awk 'BEGIN{OFS="\t"} NR > 1 {
        print $1, $2, $3, "a" NR > "'${path}'anchor1.bed";
        print $4, $5, $6, "A" NR > "'${path}'anchor2.bed";
    }' ${path}merged_out.cluster.FDRfiltered.txt
done < /data/slurm/tmmap/chiapet.txt
