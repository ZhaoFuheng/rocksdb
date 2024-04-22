#!/bin/bash

for i in 0 1 2 3 4; do
    ./db_bench.sh > "/home/ubuntu/rocksdb/db_bench_results/figure4/c_plot${i}.txt"
done
