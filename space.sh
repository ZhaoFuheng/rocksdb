#!/bin/bash

shopt -s extglob

num=689655172 # 80 Gb

T=5

# value_size=100
key_size=16

for value_size in 50 100 200; do
    echo "value_size=${value_size}"
    ./db_bench --benchmarks=fillrandom,waitforcompaction,stats \
                    -db=/db_bench \
                    -max_bytes_for_level_multiplier=${T} \
                    -compression_type=none \
                    -value_size=${value_size} \
                    -key_size=${key_size} \
                    -num=${num} \
                    -cache_index_and_filter_blocks=true \
                    -pin_l0_filter_and_index_blocks_in_cache=true \
                    --seed=1
    echo "Space taken:"
    sudo du -sh /db_bench

    sudo rm /db_bench/!(lost+found)
done