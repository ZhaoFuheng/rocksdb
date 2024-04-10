#!/bin/bash 

shopt -s extglob

num=8620689 
reads=100000

T=2
c=0.8

value_size=100
key_size=16

for fill in "filluniquerandom" "fillrandom"; do 
    for c_val in 0.4 0.5 0.6 0.7 0.8 0.9 1.0; do
        echo "-----------c=${c_val}-----------"
    # for value_size in 50 100 200; do
        echo "fill=${fill}"
        ./db_bench --benchmarks=${fill},waitforcompaction,stats \
                    -db=/db_bench \
                    -max_bytes_for_level_multiplier=${T} \
                    -autumn_c=${c_val} \
                    -compression_type=none \
                    -value_size=${value_size} \
                    -key_size=${key_size} \
                    -num=${num} \
                    -cache_index_and_filter_blocks=true \
                    -pin_l0_filter_and_index_blocks_in_cache=true \
                    --seed=1

        # echo "readrandom"
        # ./db_bench --benchmarks=readrandom,stats --statistics \
        #             -db=/db_bench \
        #             -use_existing_db=true \
        #             -max_bytes_for_level_multiplier=${T} \
        #             -autumn_c=${c_val} \
        #             -compression_type=none \
        #             -value_size=${value_size} \
        #             -key_size=${key_size} \
        #             -reads=${reads} \
        #             --seed=1

        # echo "seekrandom"
        # ./db_bench --benchmarks=seekrandom,stats --statistics \
        #             -db=/db_bench \
        #             -use_existing_db=true \
        #             -max_bytes_for_level_multiplier=${T} \
        #             -autumn_c=${c_val} \
        #             -compression_type=none \
        #             -value_size=${value_size} \
        #             -key_size=${key_size} \
        #             -reads=${reads} \
        #             --seed=1

        echo "seekrandom, seek_nexts=10"
        ./db_bench --benchmarks=seekrandom,stats --statistics \
                    -db=/db_bench \
                    -use_existing_db=true \
                    -max_bytes_for_level_multiplier=${T} \
                    -autumn_c=${c_val} \
                    -compression_type=none \
                    -value_size=${value_size} \
                    -key_size=${key_size} \
                    -reads=${reads} \
                    -seek_nexts=10 \
                    -cache_index_and_filter_blocks=true \
                    -pin_l0_filter_and_index_blocks_in_cache=true \
                    --seed=1

        # echo "seekrandom, seek_nexts=100"
        # ./db_bench --benchmarks=seekrandom,stats --statistics \
        #             -db=/db_bench \
        #             -use_existing_db=true \
        #             -max_bytes_for_level_multiplier=${T} \
        #             -autumn_c=${c_val} \
        #             -compression_type=none \
        #             -value_size=${value_size} \
        #             -key_size=${key_size} \
        #             -reads=${reads} \
        #             -seek_nexts=100 \
        #             --seed=1

        sudo rm /db_bench/!(lost+found)
    done

    # for k in 2 4 8 16; do 
    #     echo "-----------k=${k}-----------"

    #     echo "fill=${fill}"
    #     ./db_bench --benchmarks=${fill},waitforcompaction,stats \
    #                 -db=/db_bench \
    #                 -max_bytes_for_level_multiplier=${k} \
    #                 -autumn_c=${c} \
    #                 -compression_type=none \
    #                 -value_size=${value_size} \
    #                 -key_size=${key_size} \
    #                 -num=${num} \
    #                 --seed=1

    #     echo "seekrandom, seek_nexts=10"
    #     ./db_bench --benchmarks=seekrandom,stats --statistics \
    #                 -db=/db_bench \
    #                 -use_existing_db=true \
    #                 -max_bytes_for_level_multiplier=${k} \
    #                 -autumn_c=${c} \
    #                 -compression_type=none \
    #                 -value_size=${value_size} \
    #                 -key_size=${key_size} \
    #                 -reads=${reads} \
    #                 -seek_nexts=10 \
    #                 --seed=1

    #     sudo rm /db_bench/!(lost+found)
    # done
done 