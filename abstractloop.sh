#!/bin/bash

all_csv="/data/slurm/tmmap/all.csv"
output_dir="/data/slurm/tmmap/loop"

mkdir -p "$output_dir"


awk -F, '{if(NR>1) print $7}' "$all_csv" | sort | uniq | while read -r value; do
    touch "${output_dir}/${value}.txt"
done

# ����hichip.txt�е�ÿ��GSM ID
while read -r gsm_id; do
    annotation_file="/data/slurm/tmmap/chiapet_out/${gsm_id}/out/annotation.txt"

    # ���annotation�ļ��Ƿ����
    if [[ -f "$annotation_file" ]]; then
        # ��all.csv���ҵ���������gsm_idƥ����У�����ȡ�����е�ֵ��Ϊ����ļ���
        awk -F, -v gsm="$gsm_id" -v annotation="$annotation_file" -v output_dir="$output_dir" 'NR>1 && $3 == gsm {
            filename = $7
            # ��annotation.txt��ȡ��4,5,6,10,11,12�в�д����Ӧ��txt�ļ�
            while ((getline line < annotation) > 0) {
                split(line, fields, "\t")
                print fields[4], fields[5], fields[6], fields[10], fields[11], fields[12] >> (output_dir "/" filename ".txt")
            }
            close(annotation)
        }' "$all_csv"
    else
        echo "Annotation file $annotation_file does not exist. Skipping."
    fi

done < /data/slurm/tmmap/hichip.txt
