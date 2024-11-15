while read line; 
do  cd /data/slurm/tmmap/chiapet_out/${line}/out/;
echo "${line}";
intersectBed -a /data/slurm/tmmap/chiapet_out/${line}/out/anchor1.bed -b /data/slurm/tmmap/references/enhancer.bed -wo > /data/slurm/tmmap/chiapet_out/${line}/out/anchor1_E.bed;
intersectBed -a /data/slurm/tmmap/chiapet_out/${line}/out/anchor1.bed -b /data/slurm/tmmap/references/promoter2.bed -wo > /data/slurm/tmmap/chiapet_out/${line}/out/anchor1_P.bed;
intersectBed -a /data/slurm/tmmap/chiapet_out/${line}/out/anchor2.bed -b /data/slurm/tmmap/references/enhancer.bed -wo > /data/slurm/tmmap/chiapet_out/${line}/out/anchor2_E.bed;
intersectBed -a /data/slurm/tmmap/chiapet_out/${line}/out/anchor2.bed -b /data/slurm/tmmap/references/promoter2.bed -wo > /data/slurm/tmmap/chiapet_out/${line}/out/anchor2_P.bed;
done < /data/slurm/tmmap/chiapet.txt

while read line; 
do  cd /data/slurm/tmmap/hichip_out/${line}/;
echo "${line}";
intersectBed -a /data/slurm/tmmap/hichip_out/${line}/anchor1.bed -b /data/slurm/tmmap/references/enhancer.bed -wo > /data/slurm/tmmap/hichip_out/${line}/anchor1_E.bed;
intersectBed -a /data/slurm/tmmap/hichip_out/${line}/anchor1.bed -b /data/slurm/tmmap/references/promoter2.bed -wo > /data/slurm/tmmap/hichip_out/${line}/anchor1_P.bed;
intersectBed -a /data/slurm/tmmap/hichip_out/${line}/anchor2.bed -b /data/slurm/tmmap/references/enhancer.bed -wo > /data/slurm/tmmap/hichip_out/${line}/anchor2_E.bed;
intersectBed -a /data/slurm/tmmap/hichip_out/${line}/anchor2.bed -b /data/slurm/tmmap/references/promoter2.bed -wo > /data/slurm/tmmap/hichip_out/${line}/anchor2_P.bed;
done < /data/slurm/tmmap/hichip.txt
