#!/bin/bash 

shopt -s extglob

num=8620689 # 1 Gb 
reads=1000000

# T=2
# c=0.8

value_size=100
key_size=16
for T in 3 5; do
    echo "-----------T=${T}-----------"
    for c in 0.4 0.6 0.8 1.0; do
        echo "-----------c=${c}-----------"
        echo "fillrandom"
        ./db_bench --benchmarks=fillrandom,waitforcompaction,stats \
                    -db=/db_bench \
                    -max_bytes_for_level_multiplier=${T} \
                    -autumn_c=${c} \
                    -compression_type=none \
                    -value_size=${value_size} \
                    -key_size=${key_size} \
                    -num=${num} \
                    -cache_size=0 \
                    -use_direct_reads=true \
                    -use_direct_io_for_flush_and_compaction=true \
                    --seed=1

        echo "readrandom (to finish compactions if necessary)"
        ./db_bench --benchmarks=readrandom,stats --statistics \
                    -db=/db_bench \
                    -use_existing_db=true \
                    -max_bytes_for_level_multiplier=${T} \
                    -autumn_c=${c} \
                    -compression_type=none \
                    -value_size=${value_size} \
                    -key_size=${key_size} \
                    -reads=${reads} \
                    -cache_size=0 \
                    -use_direct_reads=true \
                    -use_direct_io_for_flush_and_compaction=true \
                    --seed=1

        echo "seekrandom, seek_nexts=10"
        ./db_bench --benchmarks=seekrandom,stats --statistics \
                    -db=/db_bench \
                    -use_existing_db=true \
                    -max_bytes_for_level_multiplier=${T} \
                    -autumn_c=${c} \
                    -compression_type=none \
                    -value_size=${value_size} \
                    -key_size=${key_size} \
                    -reads=${reads} \
                    -seek_nexts=10 \
                    -cache_size=0 \
                    -use_direct_reads=true \
                    -use_direct_io_for_flush_and_compaction=true \
                    --seed=1
        sudo rm /db_bench/!(lost+found) 
    done 
done