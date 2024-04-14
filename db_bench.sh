#!/bin/bash 

shopt -s extglob

num=2000000 
reads=1000000

T=2
# c=0.8

# value_size=100
key_size=16

for value_size in 50 100 200; do
    echo "value_size=${value_size}"
    echo "fillseq"
    ./db_bench --benchmarks=fillseq,waitforcompaction,stats \
                -db=/db_bench \
                -max_bytes_for_level_multiplier=${T} \
                -compression_type=none \
                -value_size=${value_size} \
                -key_size=${key_size} \
                -num=${num} \
                -cache_index_and_filter_blocks=true \
                -pin_l0_filter_and_index_blocks_in_cache=true \
                --seed=1

    sudo rm /db_bench/!(lost+found) 

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

    echo "readrandom (to finish compactions if necessary)"
    ./db_bench --benchmarks=readrandom,stats --statistics \
                -db=/db_bench \
                -use_existing_db=true \
                -max_bytes_for_level_multiplier=${T} \
                -compression_type=none \
                -value_size=${value_size} \
                -key_size=${key_size} \
                -reads=${reads} \
                -cache_index_and_filter_blocks=true \
                -pin_l0_filter_and_index_blocks_in_cache=true \
                --seed=1

    echo "readrandom"
    ./db_bench --benchmarks=readrandom,stats --statistics \
                -db=/db_bench \
                -use_existing_db=true \
                -max_bytes_for_level_multiplier=${T} \
                -compression_type=none \
                -value_size=${value_size} \
                -key_size=${key_size} \
                -reads=${reads} \
                -cache_index_and_filter_blocks=true \
                -pin_l0_filter_and_index_blocks_in_cache=true \
                --seed=1

    echo "seekrandom"
    ./db_bench --benchmarks=seekrandom,stats --statistics \
                -db=/db_bench \
                -use_existing_db=true \
                -max_bytes_for_level_multiplier=${T} \
                -compression_type=none \
                -value_size=${value_size} \
                -key_size=${key_size} \
                -reads=${reads} \
                -cache_index_and_filter_blocks=true \
                -pin_l0_filter_and_index_blocks_in_cache=true \
                --seed=1

    echo "seekrandom, seek_nexts=10"
    ./db_bench --benchmarks=seekrandom,stats --statistics \
                -db=/db_bench \
                -use_existing_db=true \
                -max_bytes_for_level_multiplier=${T} \
                -compression_type=none \
                -value_size=${value_size} \
                -key_size=${key_size} \
                -reads=${reads} \
                -seek_nexts=10 \
                -cache_index_and_filter_blocks=true \
                -pin_l0_filter_and_index_blocks_in_cache=true \
                --seed=1

    echo "seekrandom, seek_nexts=100"
    ./db_bench --benchmarks=seekrandom,stats --statistics \
                -db=/db_bench \
                -use_existing_db=true \
                -max_bytes_for_level_multiplier=${T} \
                -compression_type=none \
                -value_size=${value_size} \
                -key_size=${key_size} \
                -reads=${reads} \
                -seek_nexts=100 \
                -cache_index_and_filter_blocks=true \
                -pin_l0_filter_and_index_blocks_in_cache=true \
                --seed=1

    sudo rm /db_bench/!(lost+found) 
done
