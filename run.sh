#!/bin/bash

for i in 0 1; do
    ./db_bench.sh > "/home/ubuntu/rocksdb/db_bench_results/figure3/rocks_comp${i}.txt"
done